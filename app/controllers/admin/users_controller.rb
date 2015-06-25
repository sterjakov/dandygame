# -*- encoding : utf-8 -*-
class Admin::UsersController < ApplicationController

  load_and_authorize_resource

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  layout 'back'

  # GET /admin/users
  def index
    @users = User.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin/users/1
  def show
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
  end

  # POST /admin/users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to [:edit, :admin, @user], notice: 'Создание ' + t('activerecord.models.user.sozdanie') + ' прошло успешно!'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/users/1
  def update
    if @user.update(user_params)
      redirect_to [:edit, :admin, @user], notice: 'Обновление ' + t('activerecord.models.user.sozdanie') + ' прошло успешно!'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/users/1
  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: 'Удаление ' + t('activerecord.models.user.sozdanie') + ' прошло успешно!'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:nickname, :email, :password, :password_salt, :password_confirmation, :days, :role,
                                   :description, :avatar, :confirm, :token, :action, :captcha_key, :captcha,
                                   :remember_me)
    end

end
