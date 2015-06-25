# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base

  include SimpleCaptcha::ControllerHelpers

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :device_type, :user_agent
  before_action  :current_user, :js_variables, :params_for_cancan, :set_referer

  protect_from_forgery

  rescue_from ActionController::RoutingError, with: :error_404
  rescue_from ActiveRecord::RecordNotFound, with: :error_404


  before_filter :allow_iframe_requests

  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end



  def error_404
    render '/page/error_404', :status => 404
  end






  rescue_from CanCan::AccessDenied do |exception|

    unless URI(request.path).path == '/login'
      redirect_to '/login', :notice => 'У вас нет прав на выполнение этого действия или просмотра этой страницы!'
    else
      redirect_to :root
    end

  end





  # Багфикс CANCAN
  def params_for_cancan
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end





  # Записываем реферальный ID
  def set_referer

    if @current_user.nil?
      session[:referer] = params[:ref] if params[:ref].present?
    end

  end





  # ip адрес юзера
  def remote_ip
    if request.remote_ip == '127.0.0.1'
      # Hard coded remote address
      request.env['HTTP_X_REAL_IP']
    else
      request.remote_ip
    end
  end





  # Загружаем данные пользователя
  # (Внимание: Используется CanCan'ом)
  def current_user

    if cookies[:user_id] and cookies[:auth_token]
      @current_user ||= User.where( id: cookies[:user_id], auth_token: cookies[:auth_token], confirm: '1' ).first
    else
      @current_user ||= User.where( id: session[:user_id], auth_token: session[:auth_token], confirm: '1' ).first
    end

    # Активность пользователя
    @current_user.touch if @current_user and @current_user.updated_at.to_date < Date.today

    @current_user

  end





  # Назначаем общие переменные JavaScript
  def js_variables
    gon.action_name   = action_name
    gon.device_type   = device_type
  end





  # Тип устройства пользователя
  def device_type
    request.env['mobvious.device_type']
  end




  # Информация о браузере пользователя
  def user_agent
    UserAgent.parse(request.env["HTTP_USER_AGENT"])
  end





  # Валидация браузеров
  def browser_compare

    if !(controller_name == 'page')

      # Минимально допустимые версии браузера
      compare_browsers = [
          ['Internet Explorer', '9'],
          ['Chrome', '33.0.1750'],
          ['Firefox', '3.0'],
          ['Opera', '3.0'],
          ['Safari', '3.0']
      ]

      # Текущая версия браузера пользователя
      browser = user_agent.browser
      version = user_agent.version

      # Если есть браузер из списка и его версия меньше допустимой
      compare_browsers.map do |compare_browser|
        redirect_to '/page/change_browser' if compare_browser[0] == user_agent.browser && Gem::Version.new(compare_browser[1]) > Gem::Version.new(version)
      end

    end

  end







  # Валидирует так как обычно это делает valid?, но через каждые три запроса дополнительно проверяет каптчу
  def valid_with_captcha_roller? model

    action_roll_name = "#{controller_name}_#{action_name}_request_count"

    session[:"#{action_roll_name}"] = 0 unless session[:"#{action_roll_name}"]

    if session[:"#{action_roll_name}"] >= 3

      if model.is_captcha_valid?

        session[:"#{action_roll_name}"] = 0
        model.valid?

      else
        session[:"#{action_roll_name}"] += 1
        false
      end

    else

      if model.valid?
        true
      else
        session[:"#{action_roll_name}"] += 1
        false
      end

    end

  end

end
