# -*- encoding : utf-8 -*-
class Day < ActiveRecord::Base

  belongs_to :training

  has_many :comments

  has_many :day_attachments, dependent: :destroy

  accepts_nested_attributes_for :day_attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order('number ASC') }

  before_save :update_training_day_count

  validates :number, numericality: true

  #def to_param
  #  "#{number}"
  #end

  def update_training_day_count
    @training = self.training
    @training.day_count = self.training.days.count
    @training.save
  end

  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end



end
