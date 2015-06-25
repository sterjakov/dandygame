# -*- encoding : utf-8 -*-
class Comment < ActiveRecord::Base

  include ValidateContent

  has_ancestry

  belongs_to :user

  validate :max_level, :feedback_comment_length_validator

  validate :html_tags_validator, :url_validator, :antiflood

  before_save :antimat
  after_save :notify_author



  def notify_author

    if self.parent and self.parent.user.notify_comment == 1

      day = Day.find(self.parent.day_id)

      UserMailer.new_comment(parent.user, self, day).deliver()

    end

  end





  def feedback_comment_length_validator

    if self.depth == 0
      errors.add(:base, "Описание отзыва должно содержать не менее 10-и букв") if description.length <= 10
    else
      errors.add(:base, "Описание комментария должно содержать не менее 2-ух букв") if description.length <= 2
    end

  end


  def antiflood

    last_comment = Comment.where(user_id: user_id).order('updated_at DESC').first

    if last_comment and (Time.now - last_comment.updated_at) < 10
      errors.add(:base, "Еще не прошло 10-и секунд с момента вашей последней публикации или ее обновления!")
    end

  end

  def max_level
    errors.add(:base, "Вы достигли предела вложенности для этой ветки комментариев!") if depth >= 10
  end


  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end
end
