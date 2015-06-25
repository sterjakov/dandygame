# -*- encoding : utf-8 -*-
class Contact < ActiveRecord::Base

  apply_simple_captcha :message => "введен неверно!"

  validates :description, length: { minimum: 10, message: "письма должно содержать не менее 10 символов!" }
  validates :theme,       length: { minimum: 10, message: "письма должна содержать не менее 10 символов!" }
  validates :email, email: true

  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end
end
