# -*- encoding : utf-8 -*-
class Activation < ActiveRecord::Base



  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end
end
