class AuthController < ApplicationController

  layout 'front'

  skip_before_filter :verify_authenticity_token, :only => [:login_for_ads]



  # Логин форма
  def login
    @user = User.new

    authorize! :login, @user

    # SEO
    @meta_title       = "Вход"
  end






  # Логин процесс
  def login_process

    @user = User.new(login_params)

    authorize! :login, @user

    @user.action = 'login'

    if valid_with_captcha_roller?(@user)

      @user = User.where(email: login_params[:email])

      if @user.count > 0

        @user = @user.first

        if @user.password_compare? login_params[:password]

          @user.request_referer = URI(login_params[:request_referer]).path
          authorize_by! @user

        else

          @user.errors.add(:base, 'Неправильный пароль!')
          render 'login'

        end

      else
        @user = User.new
        @user.errors.add(:base, 'Нет пользователя с таким email!')
        render 'login'
      end

    else
      render 'login'
    end
  end





  # Процесс логина для рекламного робота
  def login_for_ads

    ads = Rails.application.secrets['ads']

    if params['login'] == ads['login'] and params['password'] == ads['password']

      if user = User.where(email: params[:login]).first
        authorize_by! user
      else
        render '/page/error_404', :status => 404
      end

    else

      render '/page/error_404', :status => 404

    end



  end






  # Регистрация форма
  def signup
    @user = User.new
    authorize! :signup, @user

    # SEO
    @meta_title       = "Регистрация"
  end






  # Отправляем проверочный URL на e-mail
  def signup_process

    @user = User.new(signup_params)

    authorize! :signup, @user

    @user.action = 'signup'
    @user.role = 1

    # Если валидация прошла
    if @user.valid?

      @user.encrypt_password
      @user.auth_token = @user.generate_token

      # Если письмо с подтверждением успешно отправляется
      if UserMailer.signup_request(@user).deliver

        # Сохраняем нового пользователя
        @user.notify_comment = 1
        @user.notify_day     = 1
        @user.notify_news    = 1
        @user.save

        # Перенаправляем нового пользователя обратно
        redirect_to request.referer + '#get_access_now', flash: { access_sended: true, email_sended: @user.email, action: 'users' }

      # Если письмо с подтверждением не отправляется
      else

        # Перенаправляем обратно и выводим ошибки
        @user.errors.add(:base, 'Письмо с активацией вашего акканта не удалось отправить. Попробуйте еще раз.')
        redirect_to request.referer + '#get_access_now', flash: { errors: @user.errors.full_messages, action: 'users' }
      end

    # Если валидация не прошла
    else

      # Перенаправляем обратно и выводим ошибки
      redirect_to request.referer + '#get_access_now', flash: { errors: @user.errors.full_messages, action: 'users' }
    end

  end







  # Проверка auth_token
  def signup_verify

    if @user = User.where(auth_token: params[:token]).first

      if(@user.confirm == 1)
        redirect_to training_path(params[:training_id]), flash: { error: "Аккаунт #{@user.email} уже активирован!", action: 'users' }
      else

        # Подтверждение пользователя
        @user.confirm = 1
        @user.save

        # Добавляем пользователю 1-ый день тренинга
        @mytraining              = Mytraining.new()
        @mytraining.training_id  = params[:training_id]
        @mytraining.user_id      = @user[:id]
        @mytraining.day_number   = 1
        @mytraining.save

        # Удаляем дубликаты e-mail
        User.destroy_all(confirm: nil, email: @user[:email])



        authorize_by! @user


      end

    else
      redirect_to training_path(params[:training_id]), flash: { error: 'Эта токен активации не действителен!', action: 'users' }
    end


    #render text: params[:token]

  end





  # Последний шаг регистрации форма
  def signup_complete

    authorize! :signup_complete, @current_user

    if @current_user.role > 1
      redirect_to :root
    else
      @user = User.new
    end

    # SEO
    @meta_title       = "Последний шаг"

  end






  # Последний шаг регистрации процесс
  def signup_complete_process

    @user = User.new(signup_complete_params)

    authorize! :signup_complete, @user

    @user.action = 'signup_complete'

    if valid_with_captcha_roller?(@user)

      @current_user.assign_attributes(signup_complete_params.except("avatar"))
      @current_user.avatar = signup_complete_params.delete("avatar")
      @current_user.role = 2
      @current_user.save

      flash[:signup_complete] = true
      redirect_to training_day_path(@current_user.mytraining[0].training_id, @current_user.mytraining[0].day_number)

    else
      render 'signup_complete'
    end

  end



  # Запрос на восставновление пароля
  def remember
    @user = User.new

    # SEO
    @meta_title       = "Восстановление пароля"
  end

  def remember_process

    @user = User.new(remember_params)
    @user.action = 'remember'

    if valid_with_captcha_roller?(@user)
      if user = User.where(email: remember_params[:email], confirm: 1).first
        user[:password_token] = user.generate_token
        user.save

        UserMailer.remember_password_request(user).deliver
        render 'password_sended'
      else
        @user.errors.add(:base, "Пользователь с таким e-mail не зарегистрирован!")
        render 'remember'
      end

    else
      render 'remember'
    end

  end

  # Смена пароля по password_token
  def password_recovery
    @user = User.where(password_token: params[:token])

    if @user.count > 0
      @user = @user.first
    else
      redirect_to '/remember', flash: { error: 'Ваша ссылка для восстановления пароля не действительна.'  }
    end

    # SEO
    @meta_title       = "Смена пароля"



  end

  def password_recovery_process

    if @user = User.where(password_token: params[:token]).first

      @user.action = 'password_recovery'

      @user.assign_attributes(password_recovery_params)

      if valid_with_captcha_roller?(@user)
        @user.password = password_recovery_params[:new_password]
        @user.encrypt_password
        @user.auth_token = @user.generate_token
        @user[:password_token] = ''
        @user.save
        redirect_to '/login', flash: { success: 'Пароль успешно сменен!', action: 'users'  }
      else
        render 'password_recovery'
      end


    else
      redirect_to '/remember', flash: { error: 'Ваша ссылка для восстановления пароля не действительна.', action: 'users'  }
    end

  end


  def logout
    session.delete(:user_id)
    session.delete(:auth_token)

    cookies.delete(:user_id)
    cookies.delete(:auth_token)

    if request.referer.match('/error_404').nil?
      redirect_to :back
    else
      redirect_to :root
    end

  end







  private

    # Only allow a trusted parameter "white list" through.
    def login_params
      params.require(:user).permit(:email, :password, :strange_computer, :request_referer, :captcha, :captcha_key)
    end

    # Only allow a trusted parameter "white list" through.
    def signup_params
      params.require(:user).permit(:email, :password, :password_confirmation, :vkontakte_id, :training_id, :captcha, :captcha_key)
    end

    # Only allow a trusted parameter "white list" through.
    def signup_complete_params
      params.require(:user).permit(:nickname, :birthday, :gender, :country, :city, :avatar, :crop, :captcha,
                                   :captcha_key)
    end

    # Only allow a trusted parameter "white list" through.
    def password_recovery_params
      params.require(:user).permit(:new_password, :new_password_confirmation, :password_token, :captcha, :captcha_key)
    end

    # Only allow a trusted parameter "white list" through.
    def remember_params
      params.require(:user).permit(:email, :captcha, :captcha, :captcha_key)
    end




  # Процесс авторизации
    def authorize_by! user

      auth_token = user.generate_token

      if params[:user] and login_params[:strange_computer] == "1"
        session[:user_id]    = user[:id]
        session[:auth_token] = auth_token
      else
        cookies[:user_id]    = user[:id]
        cookies[:auth_token] = auth_token
      end

      user.auth_token     = auth_token
      user.ip             = remote_ip
      user.referer        = session[:referer]

      user.save


      if user.request_referer

        # Если пользователь запрашивал страницу тренинга
        if user.request_referer.match /\/trainings/

          return redirect_to user.request_referer

        end


        # Если пользователь запрашивал страницу настроек
        if user.request_referer.match /\/settings/
          return redirect_to user.request_referer
        end

      end


      # Если это активированный пользователь
      if user.role >= 2


        #if request.referer


        # Если у пользователя только один тренинг
        if user.mytraining.count == 1

          redirect_to training_day_path(user.mytraining[0].training_id, user.mytraining[0].day_number)

        # Если у пользователя больше одного тренинга
        elsif user.mytraining.count > 1

          redirect_to :root

        # Если у пользователя нет тренингов
        else

          redirect_to :root

        end




      # Если это не активированный пользователь
      elsif user.role == 1

        redirect_to '/signup_complete'

      else

        redirect_to :root

      end

    end


end
