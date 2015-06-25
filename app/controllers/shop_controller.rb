class ShopController < ApplicationController

  layout 'front'


  # Магазин "пакетов дней"
  # GET /shop
  def index

    authorize! :edit, Order
    @order = Order.new()

    # SEO
    @meta_title = 'Оплата'

  end



  # Статус платежа
  # GET /shop/(bad|good)
  def order_status
    authorize! :edit, Order
    flash[:order_status] = params[:order_status]
    redirect_to '/shop'
  end



  # Регистрация платежа
  # и перенаправление на Robokassa
  # POST /shop
  def order_create

    authorize! :edit, Order

    @order         = Order.new(order_params)
    @order.user_id = @current_user[:id]
    @order.status  = 0


    if @order.validate

      @order.save

      @login      = 'dandygame'
      @price      = Order::PRICE.select{|key,hash| key[:id] == @order[:item_id]}[0]
      @password_1 = Rails.application.secrets['robokassa']['password_1']

      # Хеш для инициализации оплаты в Robokassa
      # Шаблон: sMerchantLogin:nOutSum:nInvId:sMerchantPass1[:пользовательские параметры, в отсортированном порядке]
      @signature  = Digest::MD5.hexdigest("#{@login}:#{@price[:cost]}:#{@order[:id]}:#{@password_1}")

      render '/shop/order_create'
    else
      render 'index'
    end

  end



  # Когда оплата прошла
  # POST /shop/order_update
  #OutSum=nOutSum&
  #InvId=nInvId&
  #SignatureValue=sSignatureValue
  #nOutSum:nInvId:sMerchantPass2[:пользовательские параметры, в отсортированном порядке]
  def order_update

    if @order = Order.where(id: params['InvId'], status: 0).first

      @price      = Order::PRICE.select{|key,hash| key[:id] == @order[:item_id]}[0]
      @password_2 = Rails.application.secrets['robokassa']['password_2']
      @signature  = Digest::MD5.hexdigest("#{params["OutSum"]}:#{params["InvId"]}:#{@password_2}").upcase

      if @signature == params['SignatureValue'].upcase

        @order.status = 1
        @order.save

        @order.user.money += @price[:number]
        @order.user.save

        render text: "OK#{@order[:id]}"

      else

        render text: "Цифровая подпись не совпадает!"

      end


    else

      render text: 'Заказ не найден!'

    end



  end



  private

    def order_params

      params.require(:order).permit(:item_id, :user_id, :captcha, :captcha_key)

    end

end
