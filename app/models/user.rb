# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader

  has_many :comments,   dependent: :destroy
  has_many :orders,     dependent: :destroy
  has_many :feedbacks,  dependent: :destroy
  has_many :mytraining, dependent: :destroy


  apply_simple_captcha :message => "введен неверно!"

  attr_accessor :password_confirmation, :strange_computer, :action, :email_message, :password, :crop,
                :new_password, :new_password_confirmation, :password_token, :request_referer, :training_id

  with_options if: "action == 'login'" do |login|
    login.validates :password, presence: true
    login.validates :email, email: true
  end

  with_options if: "action == 'signup'" do |signup|
    signup.validates :password, presence: true
    signup.validates :training_id, presence: { message: 'не выбран' }
    signup.validates :email, email: true
    signup.validates :email, uniqueness: { conditions: -> { where.not(confirm: 0) }  }
    signup.validates :password, confirmation: { message: "не совпадают" }
  end

  with_options if: "action == 'remember'" do |remember|
    remember.validates :email, email: true
  end

  with_options if: "action == 'signup_complete' or action == 'info'" do |signup_complete|
    signup_complete.validates :nickname, length: { minimum: 2, maximum: 20 }
    signup_complete.validates :nickname, uniqueness: true
    signup_complete.validates :gender, inclusion: { in: [ 0, 1 ], message: 'указан неверно' }
    signup_complete.validates :birthday, numericality: { message: 'указан неверно' }
    #signup_complete.validates :city, numericality: { message: 'указан неверно' }
    #signup_complete.validates :country, numericality: { message: 'указана неверно' }
  end

  with_options if: "action == 'password_recovery' or action == 'password_change'" do |password|
    password.validates :new_password, confirmation: { message: "не совпадают" }
    password.validates :new_password, length: { minimum: 5 }
  end

  with_options if: "action == 'email'" do |email|
    email.validates :password, presence: true
    email.validates :new_email, email: true
  end



  # Деньги есть?
  def have_money?

    self.money > 0

  end



  # Генерируем хэшь и соль для пароля
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = Digest::MD5.hexdigest(password + password_salt)
    end
  end



  # Пароль совпадает
  def password_compare? password
    self.password_hash == Digest::MD5.hexdigest(password + password_salt)
  end



  # Генерация токена
  def generate_token
    SecureRandom.hex(20) + "_" + Time.zone.now.strftime("%m%d%Y%H%I%S")
  end



  # Название роли
  def role_is?

    case role
      when 1
        'guest'
      when 2
        'user'
      when 3
        'admin'
      else
        false
    end

  end



  # Статус подтверждения да или нет
  def human_confirm
    if confirm == 1
      'да'
    else
      'нет'
    end
  end



  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end


end