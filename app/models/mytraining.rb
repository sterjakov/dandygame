# -*- encoding : utf-8 -*-
class Mytraining < ActiveRecord::Base

  attr_accessor :action, :description

  belongs_to :user
  belongs_to :training

  before_create :set_yesterday_activation_date
  before_update :set_activation_date
  before_save   :activation_log

  with_options if: "action == 'create'" do |create|
    create.validates :training_id, :day_number, :user_id, presence: { message: 'не указан!' }
    create.validates :training_id, uniqueness: { scope: :user_id, message: 'уже начат!' }
    create.validate :user_have_money_validator
  end

  with_options if: "action == 'update'" do |update|
    update.validates :training_id, :day_number, :user_id, presence: { message: 'не указан!' }
    update.validates :training_id, uniqueness: { scope: :user_id, message: 'уже начат!' }
    update.validate  :user_have_money_validator, :activation_date_expired_validator, :inclusion_day_validator
  end



  # Логируем активацию
  def activation_log

    Activation.new({ training_id: self.training_id, day_number: self.day_number, user_id: self.user_id, money: day_cost }).save

  end



  # Цена за день
  def day_cost

    if self.day_number <= self.training.free_day
      0
    else
      1
    end

  end



  # Назначить активацию вчерашним днем
  def set_yesterday_activation_date

    self.activated_at = Time.zone.now - 1.day

  end



  # Назначить активацию сегодняшним днем
  def set_activation_date

    if action == 'update'

      if one_day_left_at_activation_date_expired?

        set_yesterday_activation_date
      else

        self.activated_at = Time.zone.now
      end

    end

  end



  # Валидатор допустимых значений дней
  def inclusion_day_validator

    if self.day_number == 0 or self.day_number > self.training.day_count
      errors.add(:base, 'Такого дня не существует!')
    end

  end



  # Валидатор просроченности дня
  def activation_date_expired_validator

    if activation_date_not_expired?
      errors.add(:base, 'Вы не можете начать следующий день пока текущий не завершен!')
    end

  end



  # Валидатор оплаты + процесс оплаты
  def user_have_money_validator

    # Если пользователь активирует ПЛАТНЫЙ ДЕНЬ
    if day_number > self.training.free_day

      # Если денег нет
      if self.user.money < 1

        errors.add(:base, 'На вашем счету не хватает дней для продолжения тренинга! Пожалуйста пополните его для
                           того чтобы продолжить.')

      # Если деньги есть
      else

        self.user.money -= 1
        self.user.save

      end


    end

  end




  # С момента активации дня уже прошло 24 часа?
  def one_day_left_at_activation_date_expired?

    seconds_left_at_one_day_after_activation_date_expired > 0

  end




  # Сколько секунд прошло спустя 24 часа после активации последнего дня?
  def seconds_left_at_one_day_after_activation_date_expired

    -86400 - activation_date_seconds_left

  end



  # Сколько секунд прошло с момента активации последнего дня
  def activation_date_seconds_left

    # Если тренинг был добавлен до 6:00 утра
    if self.activated_at.change(hour: 6) - self.activated_at > 0

      self.activated_at.change(hour: 6) - Time.zone.now

    # Если тренинг был добавлен после 6:00 утра
    else

      self.activated_at.change(hour: 6) + 1.day - Time.zone.now

    end

  end



  # Активация просрочена?
  def activation_date_expired?

    activation_date_seconds_left < 0

  end



  # День не просрочен
  def activation_date_not_expired?

    !activation_date_expired?

  end



  # Тренинг активен?
  # 0 - Добавлен
  # 1 - Пройден
  # 2 - Скрыт
  def status_active?

    self.status == 0 or self.status == 2

  end



  # Текущий не активированный день
  def current_day

    (activation_date_expired?) ? day_number : day_number - 1

  end



  # Этот тренинг добавлен?
  def added?
    (self.training_id) ? true : false
  end



  # Этот тренинг еще не добавлен?
  def new?
    (self.training_id) ? false : true
  end



  # Номер следующего дня
  def next_day_number

    self.day_number + 1

  end



  # Окончание кол-ва дней Именительный падеж - средний род
  def nominative_human_number_ending(number)

    last_number = number.to_s[-1].to_i

    case last_number

      when 1, 9, 0
        '-ый'
      when 2, 6, 7, 8
        '-ой'
      when 3
        '-ий'
      when 4, 5
        '-ый'

    end

  end



  # Окончание кол-ва дней Именительный падеж - средний род
  def dative_human_number_ending(number)

    last_number = number.to_s[-1].to_i

    case last_number

      when 1, 9, 0
        '-ому'
      when 2, 6, 7, 8
        '-ому'
      when 3
        '-ему'
      when 4, 5
        '-ому'

    end

  end



  # Число + окончание кол-ва дней в именительном падеже
  def nominative_human_next_day_number

    next_day_number.to_s + nominative_human_number_ending(next_day_number).to_s

  end



  # Число + окончание кол-ва дней в именительном падеже
  def nominative_human_current_day_number

    day_number.to_s + nominative_human_number_ending(day_number).to_s

  end



  # Число + окончание кол-ва дней в родительном падеже
  def dative_human_next_day_number

    next_day_number.to_s + dative_human_number_ending(next_day_number).to_s

  end



  # Число + окончание кол-ва дней в родительном падеже
  def dative_human_current_day_number

    day_number.to_s + dative_human_number_ending(day_number).to_s

  end



  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end



end
