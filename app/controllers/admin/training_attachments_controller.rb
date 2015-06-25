# -*- encoding : utf-8 -*-
class Admin::TrainingAttachmentsController < ApplicationController

  load_and_authorize_resource

  before_action :set_training_attachment, only: [:show, :edit, :update, :destroy]

  layout 'back'

  before_action :current_user

  # GET /admin/training_attachments
  def index
    @training_attachments = TrainingAttachment.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin/training_attachments/1
  def show
  end

  # GET /admin/training_attachments/new
  def new
    @training_attachment = TrainingAttachment.new
  end

  # GET /admin/training_attachments/1/edit
  def edit
  end

  # POST /admin/training_attachments
  def create
    @training_attachment = TrainingAttachment.new(training_attachment_params)

    if @training_attachment.save
      redirect_to [:edit, :admin, @training_attachment], notice: 'Создание ' + t('activerecord.models.training_attachment.sozdanie') + ' прошло успешно!'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/training_attachments/1
  def update
    if @training_attachment.update(training_attachment_params)
      redirect_to [:edit, :admin, @training_attachment], notice: 'Обновление ' + t('activerecord.models.training_attachment.sozdanie') + ' прошло успешно!'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/training_attachments/1
  def destroy
    @training_attachment.destroy
    redirect_to admin_training_attachments_url, notice: 'Удаление ' + t('activerecord.models.training_attachment.sozdanie') + ' прошло успешно!'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_training_attachment
      @training_attachment = TrainingAttachment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def training_attachment_params
      params.require(:training_attachment).permit(:training_id, :attachment)
    end
end
