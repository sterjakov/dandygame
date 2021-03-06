# -*- encoding : utf-8 -*-
class <%= class_name %> < <%= parent_class_name.classify %>



  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end
end
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %>
<% end -%>
<% if attributes.any?(&:password_digest?) -%>
has_secure_password
<% end -%>