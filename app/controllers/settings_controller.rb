class SettingsController < ApplicationController

  layout 'front'

  def info
    authorize! :edit, @current_user

    # SEO
    @meta_title = "Личная информация"
  end

  def info_process
    @current_user.assign_attributes(info_params)
    @current_user.action = 'info'

    authorize! :edit, @current_user

    if valid_with_captcha_roller?(@current_user)
      @current_user.assign_attributes(info_params.except("avatar"))
      @current_user.avatar = info_params.delete("avatar")
      @current_user.save
      flash[:success] = 'Данные успешно обновлены!'
      flash[:action] = 'users'
    end

    render 'info'
  end

  def password
    authorize! :edit, @current_user

    # SEO
    @meta_title = 'Смена пароля'
  end
  
  def password_process

    @current_user.action = 'password_change'
    @current_user.assign_attributes(password_params)

    authorize! :edit, @current_user

    if valid_with_captcha_roller?(@current_user)
      @current_user.password = password_params[:new_password]
      @current_user.encrypt_password
      @current_user[:password_token] = ''
      @current_user.save
      flash[:success] = 'Пароль успешно сменен!'
      flash[:action] = 'users'
    end

    render 'password'
  end

  def email
    @user = User.new
    authorize! :edit, @current_user

    # SEO
    @meta_title = "Смена e-mail"
  end
  
  def email_process
    @current_user.assign_attributes(email_params)
    @current_user.action = 'email'

    authorize! :edit, @current_user

    if valid_with_captcha_roller?(@current_user)

      if @current_user.password_compare? @current_user.password
        @current_user.email_token = @current_user.generate_token
        @current_user.save

        if UserMailer.email_request(@current_user).deliver
          render 'email_sended'
        else
          flash[:error] = 'Что то пошло не так, попробуйте еще раз!'
          flash[:action] = 'users'
          render 'email'
        end


      else
        flash[:error] = 'Неправильный пароль!'
        flash[:action] = 'users'
        render 'email'
      end

    else
      render 'email'
    end


  end

  def email_verify

    authorize! :edit, @current_user

    if @current_user.email_token == params[:token]
      @current_user[:email] = @current_user[:new_email]
      @current_user[:new_email] = ''
      @current_user[:email_token] = ''
      @current_user.save
      flash[:success] =  "Ваш email успешно изменен на #{@current_user[:email]}"
      flash[:action] = 'users'
    else
      flash[:error] = 'Токен не совпадает или устарел!'
      flash[:action] = 'users'
    end

    redirect_to action: 'email'


  end

  def notify
    authorize! :edit, @current_user

    # SEO
    @meta_title = "Уведомления"
  end

  def notify_process
    @current_user.assign_attributes(notify_params)
    @current_user.action = 'notify'

    authorize! :edit, @current_user

    if valid_with_captcha_roller?(@current_user)
      @current_user.assign_attributes(notify_params)
      @current_user.save
      flash[:success] = 'Данные успешно обновлены!'
      flash[:action] = 'users'
    end

    render 'notify'
  end

  private

    # Only allow a trusted parameter "white list" through.
    def info_params
      params.require(:user).permit(:nickname, :birthday, :gender, :country, :city, :avatar, :crop, :captcha,
                                   :captcha_key, :remove_avatar)
    end

    # Only allow a trusted parameter "white list" through.
    def password_params
      params.require(:user).permit( :password, :new_password, :new_password_confirmation, :captcha, :captcha_key )
    end

    # Only allow a trusted parameter "white list" through.
    def email_params
      params.require(:user).permit( :password, :new_email, :captcha, :captcha_key )
    end

    # Only allow a trusted parameter "white list" through.
    def notify_params
      params.require(:user).permit( :notify_comment, :notify_day, :notify_news,  :captcha,  :captcha_key)
    end

end
