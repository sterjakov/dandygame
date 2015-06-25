# -*- encoding : utf-8 -*-
class Admin::DayAttachmentsController < ApplicationController

  load_and_authorize_resource

  before_action :set_day_attachment, only: [:show, :edit, :update, :destroy]

  layout 'back'

  before_action :current_user

  # GET /admin/day_attachments
  def index
    @day_attachments = DayAttachment.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin/day_attachments/1
  def show
  end

  # GET /admin/day_attachments/new
  def new
    @day_attachment = DayAttachment.new
  end

  # GET /admin/day_attachments/1/edit
  def edit
  end

  # POST /admin/day_attachments
  def create
    @day_attachment = DayAttachment.new(day_attachment_params)

    if @day_attachment.save
      redirect_to [:edit, :admin, @day_attachment], notice: 'Создание ' + t('activerecord.models.day_attachment.sozdanie') + ' прошло успешно!'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/day_attachments/1
  def update
    if @day_attachment.update(day_attachment_params)
      redirect_to [:edit, :admin, @day_attachment], notice: 'Обновление ' + t('activerecord.models.day_attachment.sozdanie') + ' прошло успешно!'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/day_attachments/1
  def destroy
    @day_attachment.destroy
    redirect_to admin_day_attachments_url, notice: 'Удаление ' + t('activerecord.models.day_attachment.sozdanie') + ' прошло успешно!'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_day_attachment
      @day_attachment = DayAttachment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def day_attachment_params
      params.require(:day_attachment).permit(:day_id, :attachment)
    end
end
