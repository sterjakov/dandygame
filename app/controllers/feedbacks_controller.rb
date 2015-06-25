class FeedbacksController < ApplicationController

  def create

    @feedback = Feedback.new(feedback_params)

    authorize! :create, @feedback

    @feedback.user_id = @current_user[:id]
    @feedback.training_id  = params[:training_id]

    if @feedback.save
      @mytraining = Mytraining.where(user_id: @current_user[:id], training_id: params[:training_id]).first
      @mytraining.status = 1
      @mytraining.save

      redirect_to training_path(params[:training_id]) + "#training-actions", flash: { feedback: @feedback.id, action: 'feedbacks' }
    else
      redirect_to request.referer + "#training-actions",
                  flash: { errors: @feedback.errors.full_messages, action: 'feedbacks', feedback: @feedback.description }
    end

  end

  def update

    if @feedback = Feedback.find(params[:id])
      @feedback.assign_attributes(feedback_params)
    else
      return redirect_to request.referer + "#feedbacks", flash: { error: 'Вы пытаетесь отредактировать несуществующий отзыв!', action: 'feedbacks' }
    end

    authorize! :edit, @feedback

    @feedback.user_id      = @current_user[:id]
    @feedback.training_id  = params[:training_id]

    if @feedback.save
      redirect_to request.referer + "#feedback-id_#{@feedback.id}", flash: { feedback: @feedback.id, action: 'feedbacks' }
    else
      redirect_to request.referer + "#feedbacks", flash: { errors: @feedback.errors.full_messages, action: 'feedbacks', feedback: @feedback.description }
    end

  end


  def destroy

    unless @feedback = Feedback.find(params[:id])
      return redirect_to request.referer + "#feedbacks", flash: { error: 'Вы пытаетесь удалить несуществующий отзыв!', action: 'feedbacks' }
    end

    authorize! :delete, @feedback

    if @feedback.destroy

      @mytraining = Mytraining.where(user_id: @current_user[:id], training_id: @feedback[:training_id]).first
      @mytraining.status = 0
      @mytraining.save

      redirect_to training_day_path(@mytraining[:training_id], @mytraining[:day_number]) + "#training-actions",
                  flash: { success: 'Отзыв успешно удален!', action: 'feedbacks' }
    else
      redirect_to request.referer + "#feedbacks", flash: { errors: @feedback.errors.full_messages, action: 'feedbacks' }
    end

  end


  private

  # Only allow a trusted parameter "white list" through.
  def feedback_params
    params.require(:feedback).permit( :training_id, :description, :captcha, :captcha_key)
  end

end
