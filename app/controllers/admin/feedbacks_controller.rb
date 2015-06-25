# -*- encoding : utf-8 -*-
class Admin::FeedbacksController < ApplicationController

  load_and_authorize_resource

  before_action :set_feedback, only: [:show, :edit, :update, :destroy]

  layout 'back'

  before_action :current_user

  # GET /admin/feedbacks
  def index
    @feedbacks = Feedback.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin/feedbacks/1
  def show
  end

  # GET /admin/feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # GET /admin/feedbacks/1/edit
  def edit
  end

  # POST /admin/feedbacks
  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      redirect_to [:edit, :admin, @feedback], notice: 'Создание ' + t('activerecord.models.feedback.sozdanie') + ' прошло успешно!'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/feedbacks/1
  def update
    if @feedback.update(feedback_params)
      redirect_to [:edit, :admin, @feedback], notice: 'Обновление ' + t('activerecord.models.feedback.sozdanie') + ' прошло успешно!'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/feedbacks/1
  def destroy
    @feedback.destroy
    redirect_to admin_feedbacks_url, notice: 'Удаление ' + t('activerecord.models.feedback.sozdanie') + ' прошло успешно!'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def feedback_params
      params.require(:feedback).permit(:user_id, :training_id, :description, :bad, :good, :status)
    end
end
