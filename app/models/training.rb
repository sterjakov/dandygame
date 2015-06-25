# -*- encoding : utf-8 -*-
class Training < ActiveRecord::Base

  belongs_to :category
  belongs_to :user
  has_one :mytraining

  has_many :user_trainings
  has_many :users, through: :user_trainings

  has_many :feedbacks
  has_many :days
  has_many :training_attachments, dependent: :destroy
  accepts_nested_attributes_for :training_attachments, reject_if: :all_blank, allow_destroy: true

  before_save :set_alternative_name

  validates :weight, numericality: true


  def get_available_weights

    # Какие веса уже заняты тренингами
    current_weights = Training.where('weight > ?', 0).map { |t| t.weight }

    # Все допустимые веса в тренингах
    all_weights     = Array.new(Training.count + 1){|i| i*10 }.reverse

    # Какие веса свободны
    if self.weight.present?
      (all_weights - current_weights + [self.weight]).sort.reverse
    else
      (all_weights - current_weights).sort.reverse
    end


  end

  STATUS = [ ['В разработке',0], ['Активный',1], ['Бета тест',2] ]

  def get_status
    STATUS.map{ |k,v| return k if v == self.status.to_i }
  end

  def set_alternative_name
    self.alt_name = Russian::translit(self.name).downcase.gsub(' ','-')
  end

  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end
end
