# -*- encoding : utf-8 -*-
class Admin::CategoriesController < ApplicationController

  load_and_authorize_resource

  before_action :set_admin_category, only: [:show, :edit, :update, :destroy]

  layout 'back'

  before_action :current_user

  # GET /admin/categories
  def index
    @admin_categories =Category.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin/categories/1
  def show
  end

  # GET /admin/categories/new
  def new
    @category =Category.new
  end

  # GET /admin/categories/1/edit
  def edit
  end

  # POST /admin/categories
  def create
    @category =Category.new(category_params)

    if @category.save
      redirect_to [:edit, :admin, @category], notice: 'Создание ' + t('activerecord.models.category.sozdanie') + ' прошло успешно!'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/categories/1
  def update
    if @category.update(category_params)
      redirect_to [:edit, :admin, @category], notice: 'Обновление ' + t('activerecord.models.category.sozdanie') + ' прошло успешно!'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/categories/1
  def destroy
    @category.destroy
    redirect_to admin_categories_url, notice: 'Удаление ' + t('activerecord.models.category.sozdanie') + ' прошло успешно!'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_category
      @category =Category.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      params.require(:category).permit(:name, :alt_name)
    end
end
