# -*- encoding : utf-8 -*-
class DayAttachment < ActiveRecord::Base

  belongs_to :day
  mount_uploader :attachment, AttachmentUploader

  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end
end
