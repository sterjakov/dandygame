# -*- encoding : utf-8 -*-
class Admin::TrainingsController < ApplicationController

  load_and_authorize_resource

  before_action :set_training, only: [:show, :edit, :update, :destroy]

  before_action :current_user

  layout 'back'

  # POST /admin/trainings/ajax_weight
  def ajax_weight
    @training = Training.find(params[:id])
    text = (@training.update(weight: params[:weight])) ? true : false
    render text: text
  end

  # GET /admin/trainings
  def index
    @trainings = Training.paginate(:page => params[:page], :per_page => 20).order('weight DESC')
  end

  # GET /admin/trainings/1
  def show
  end

  # GET /admin/trainings/new
  def new
    @training = Training.new

    3.times do
      @training.training_attachments.build
    end
  end

  # GET /admin/trainings/1/edit
  def edit
    # Следующий тренинг
    @next_training = Training.select(:id, :name).where("weight < #{@training[:weight]}").order('weight DESC').first
    unless @next_training
      @next_training = Training.select(:id, :name).where("weight > #{@training[:weight]}").order('weight DESC').first
    end


    # Предыдущий тренинг
    @prev_training = Training.select(:id, :name).where("weight > #{@training[:weight]}").order('weight ASC').first
    unless @prev_training
      @prev_training = Training.select(:id, :name).where("weight < #{@training[:weight]}").order('weight ASC').first
    end
  end

  # POST /admin/trainings
  def create
    @training = Training.new(training_params)

    if @training.save
      redirect_to [:edit, :admin,@training], notice: 'Создание ' + t('activerecord.models.training.sozdanie') + ' прошло успешно!'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/trainings/1
  def update
    if @training.update(training_params)
      redirect_to [:edit, :admin, @training ], notice: 'Обновление ' + t('activerecord.models.training.sozdanie') + ' прошло успешно!'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/trainings/1
  def destroy
    @training.destroy
    redirect_to admin_trainings_url, notice: 'Удаление ' + t('activerecord.models.training.sozdanie') + ' прошло успешно!'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_training
      @training = Training.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def training_params
      params.require(:training).permit(:name, :alt_name, :description, :min_description, :people_count, :day_count,
                                       :icon, :free_day, :price, :html, :css, :status, :meta_description,
                                       :meta_keywords, :weight, :feedback_count, :category_id,
                                       training_attachments_attributes: [:id, :training_id, :attachment, :_destroy])
    end
end
