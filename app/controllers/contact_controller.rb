class ContactController < ApplicationController

  layout 'front'

  def new
    @contact = Contact.new()

    # SEO
    @meta_title = "Обратная связь"
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.is_captcha_valid?

      if ContactMailer.contact_request(@contact).deliver
        return redirect_to '/contact', flash: { success: 'Письмо успешно доставлено! Наши сотрудники свяжутся с вами в течении 24 часов!', action: 'contacts' }
      else
        @contact.errors.add(:base, 'Ошибка при отпаврке письма! Попробуйте еще раз!')
        render 'contact/new'
      end

    else
      render 'contact/new'
    end


  end

  private

  def contact_params

    params.require(:contact).permit(:id, :description, :email, :theme ,:captcha, :captcha_key)

  end

end
