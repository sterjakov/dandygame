# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base

  has_many :trainings

  before_save :set_alternative_name

  def set_alternative_name
    self.alt_name = Russian::translit(self.name).downcase.gsub(' ','-')
  end

  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end
end
