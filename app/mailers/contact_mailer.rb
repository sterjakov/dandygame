class ContactMailer < ActionMailer::Base

  default from: "info@dandygame.ru"

  def contact_request contact

    @contact = contact

    mail to: 'info@dandygame.ru',
         subject: "DandyGame: " + @contact.theme,
         from: @contact.email


  end


end
