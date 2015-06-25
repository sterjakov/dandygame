# -*- encoding : utf-8 -*-
class Admin::CommentsController < ApplicationController

  load_and_authorize_resource

  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  layout 'back'

  before_action :current_user

  # GET /admin/comments
  def index
    @comments = Comment.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin/comments/1
  def show
  end

  # GET /admin/comments/new
  def new
    @comment = Comment.new
  end

  # GET /admin/comments/1/edit
  def edit
  end

  # POST /admin/comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      redirect_to [:edit, :admin, @comment], notice: 'Создание ' + t('activerecord.models.comment.sozdanie') + ' прошло успешно!'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/comments/1
  def update
    if @comment.update(comment_params)
      redirect_to [:edit, :admin, @comment], notice: 'Обновление ' + t('activerecord.models.comment.sozdanie') + ' прошло успешно!'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/comments/1
  def destroy
    @comment.destroy
    redirect_to admin_comments_url, notice: 'Удаление ' + t('activerecord.models.comment.sozdanie') + ' прошло успешно!'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comment).permit(:user_id, :day_id, :description, :bad, :good, :status)
    end
end
