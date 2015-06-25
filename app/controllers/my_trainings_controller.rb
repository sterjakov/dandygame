class MyTrainingsController < ApplicationController

  layout 'front'

  def index
    authorize! :edit, Mytraining

    @mytraining_active = Mytraining.where(status: 0, user_id: @current_user).order('day_number DESC')
    @mytraining_hidden = Mytraining.where(status: 2, user_id: @current_user).order('day_number DESC')
    @mytraining_final  = Mytraining.where(status: 1, user_id: @current_user).order('day_number DESC')

    # SEO
    @meta_title = 'Мои тренинги'

  end

  def show
    authorize! :edit, Mytraining

    if @mytraining = Mytraining.where(user_id: @current_user[:id], training_id: params[:id], status: 2).first
      @mytraining.status = 0
      @mytraining.save
    end

    redirect_to :back

  end

  def hide
    authorize! :edit, Mytraining

    if @mytraining = Mytraining.where(user_id: @current_user[:id], training_id: params[:id], status: 0).first
      @mytraining.status = 2
      @mytraining.save
    end

    redirect_to :back
  end

  def create

    authorize! :edit, Mytraining

    @mytraining            = Mytraining.new(mytraining_params)
    @mytraining.user_id    = @current_user[:id]
    @mytraining.day_number = 1
    @mytraining.action     = 'create'

    ActiveRecord::Base.record_timestamps = false

    @mytraining.updated_at = Time.zone.now - 1.day
    @mytraining.created_at = Time.zone.now

    ActiveRecord::Base.record_timestamps = true


    if @mytraining.save

      redirect_to training_day_path(@mytraining[:training_id], 1, anchor: 'content_name'),
                  flash: { training_head: 'Поздравляем вас с успешным началом онлайн тренинга. Выполняйте
                                           все задания для того чтобы получить максимальную пользу от его
                                           прохождения. <br> Желаем удачи!' }

    else

      redirect_to request.referer + '#training-actions', flash: {  errors: @mytraining.errors.full_messages, action: 'mytrainings' }

    end

  end

  def update

    authorize! :edit, Mytraining

    if @mytraining = Mytraining.where(user_id: @current_user[:id], training_id: mytraining_params[:training_id]).first


      # Добавляем комментарий к текущему дню

      @day     = Day.where(number: @mytraining[:day_number], training_id: @mytraining[:training_id]).first
      @comment = Comment.new(description: params[:mytraining][:description], day_id: @day[:id], user_id: @current_user[:id])

      unless @comment.valid?
        return redirect_to request.referer + '#training-actions',
                           flash: {  errors: @comment.errors.full_messages, action: 'mytrainings',
                           feedback_description: params[:mytraining][:description] }
      end


      # Активируем следующий день

      @mytraining[:day_number] += 1
      @mytraining[:user_id]    = @current_user[:id]
      @mytraining.action       = 'update'


      # Сохраняем комментарий и данные об активации

      if @mytraining.valid?

        @comment.save
        @mytraining.save
        redirect_to training_day_path(@mytraining[:training_id], @mytraining[:day_number], anchor: 'content_name')

      else

        redirect_to request.referer + '#training-actions',
                    flash: {  errors: @mytraining.errors.full_messages, action: 'mytrainings' }

      end

    end






  end

  private

  def mytraining_params
    params.require(:mytraining).permit(:training_id, :day_number, :user_id, :captcha, :captcha,
                                       :captcha_key, comments_attributes: [:description])
  end

end
