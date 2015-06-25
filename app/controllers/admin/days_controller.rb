# -*- encoding : utf-8 -*-
class Admin::DaysController < ApplicationController

  load_resource :find_by => :number
  authorize_resource

  before_action :set_day, only: [:show, :edit, :update, :destroy]

  layout 'back'

  before_action :current_user, :load_training

  # GET /admin/days/:id/select_field/
  def select_field
    @days = Day.where(training_id: params[:training_id])

    if @days.present?
      render partial: 'select_field' ,layout: false
    else
      render text: false
    end

  end


  # GET /admin/days/by_training/:id/
  def by_training
    @days = Day.where(training_id: params[:training_id]).paginate(:page => params[:page], :per_page => 20)
  end

  # GET /days
  def index
    @days = @training.days.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /days/1
  def show
  end

  # GET /days/new
  def new
    @day = Day.new

    3.times do
      @day.day_attachments.build
    end

  end

  # GET /days/1/edit
  def edit
  end

  # POST /days
  def create
    @day = Day.new(day_params)

    if @day.save
      redirect_to edit_admin_training_day_path(@training, @day[:number]), notice: 'Создание ' + t('activerecord.models.day.sozdanie') + ' прошло успешно!'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /days/1
  def update
    if @day.update(day_params)
      redirect_to edit_admin_training_day_path(@training, @day[:number]), notice: 'Обновление ' + t('activerecord.models.day.sozdanie') + ' прошло успешно!'
    else
      render action: 'edit'
    end
  end

  # DELETE /days/1
  def destroy
    @day.destroy
    redirect_to admin_training_days_url(@training), notice: 'Удаление ' + t('activerecord.models.day.sozdanie') + ' прошло успешно!'
  end

  private

    def load_training
      @training = Training.find(params[:training_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_day
      @day = Day.where(training_id: params[:training_id], number: params[:id]).first
    end

    # Only allow a trusted parameter "white list" through.
    def day_params
      params.require(:day).permit(:training_id, :number, :name, :description,
                                  day_attachments_attributes: [:id, :day_id, :attachment, :_destroy])
    end
end
