module ValidateContent

  extend ActiveSupport::Concern



  def html_tags_validator

    if self.description.match(/<[^>]*>/)
      errors.add(:base, "Нельзя использовать HTML теги!")
    end

  end



  def url_validator

    if URI.extract(self.description).present?
      errors.add(:base, "Нельзя публиковать ссылки!")
    end

  end

  def antimat

    self.description = RussianObscenity.sanitize(self.description, '(цензура)')

  end



end