class CommentsController < ApplicationController

  def create

    @comment = Comment.new(comment_params)

    authorize! :create, @comment

    day = Day.where( training_id: params[:training_id],  number: params[:day_id]).first

    @comment.user_id = @current_user[:id]
    @comment.day_id  = day[:id]


    if comment_params[:parent_id].present?

      @parent_comment = Comment.find(comment_params[:parent_id])

      if cannot? :create_for_own, @parent_comment
        return redirect_to request.referer + "#comments",
                           flash: { error: 'Нельзя оставлять комментарии самому себе!', action: 'comments' }
      end

    end


    if @comment.save
      redirect_to request.referer + "#comment-id_#{@comment.id}", flash: { comment: @comment.id }
    else
      redirect_to request.referer + "#comments",
                  flash: { errors: @comment.errors.full_messages, action: 'comments', comment_description: @comment.description }
    end

  end

  def update

    if @comment = Comment.find(params[:id])
      @comment.assign_attributes(comment_params)
    else
      return redirect_to request.referer + "#comments", flash: { error: 'Вы пытаетесь отредактировать несуществующий комментарий!', action: 'comments' }
    end

    authorize! :edit, @comment

    @day = Day.where(training_id: params[:training_id], number: params[:day_id]).first

    @comment.user_id = @current_user[:id]
    @comment.day_id  = @day.id

    if cannot? :edit, @comment
      return redirect_to request.referer + "#comments", flash: { error: 'У вас нет прав для редактирование этого комментария!', action: 'comments' }
    end

    if @comment.save
      redirect_to request.referer + "#comment-id_#{@comment.id}", flash: { comment: @comment.id }
    else
      redirect_to request.referer + "#comments", flash: { errors: @comment.errors.full_messages,
                                                          action: 'comments',
                                                          comment_description: @comment.description }
    end

  end


  def destroy

    unless @comment = Comment.find(params[:id])
      return redirect_to request.referer + "#comments", flash: { error: 'Вы пытаетесь удалить несуществующий комментарий!', action: 'comments' }
    end

    authorize! :delete, @comment

    if cannot? :delete, @comment
      return redirect_to request.referer + "#comments", flash: { error: 'У вас нет прав на удаления этого комментария!', action: 'comments' }
    end

    if @comment.destroy
      redirect_to request.referer + "#comments", flash: { success: 'Комментарий успешно удален!', action: 'comments' }
    else
      redirect_to request.referer + "#comments", flash: { errors: @comment.errors.full_messages, action: 'comments' }
    end

  end


  private

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit( :day_id, :description, :parent_id, :captcha, :captcha_key)
  end

end
