# -*- encoding : utf-8 -*-
class Feedback < ActiveRecord::Base

  include ValidateContent

  belongs_to :training
  belongs_to :user

  after_save :recount_training_feedbacks
  after_destroy :recount_training_feedbacks

  validates :description, length: { minimum: 90, message: "отзыва должно быть не менее 90 символов!" }
  validate :html_tags_validator, :url_validator, :antiflood

  before_save :antimat, :antiflood


  def antiflood

    last_feedback = Feedback.where(user_id: user_id, training_id: training_id).order('updated_at DESC').first

    if last_feedback and (Time.now - last_feedback.updated_at) < 20
      errors.add(:base, "Еще не прошло 20-и секунд с момента вашей последней публикации или ее обновления!")
    end

  end

  def recount_training_feedbacks

    feedback_count = Feedback.where(training_id).count
    training = Training.find(training_id)
    training.feedback_count = feedback_count
    training.save

  end

  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end
end
