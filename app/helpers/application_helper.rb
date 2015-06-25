module ApplicationHelper

  def no_touch
    (device_type == :desktop) ? 'no-touch ' : true
  end

  def is_authenticate?
    @current_user
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def active_controller(controller)
    if controller_name == controller
      'active'
    else
      nil
    end
  end

  def active_page(action)
    if controller_name == 'pages' and action_name == action
      'active'
    else
      nil
    end
  end

  def captcha_exists? name, count
    session[:"#{name}_request_count"].present? and session[:"#{name}_request_count"] >= count
  end

  def body_class_name

    if response.code == '404'
      'error-404-bg'
    elsif controller_name == 'trainings' and action_name == 'show' or controller_name == 'days' and action_name == 'show'
      nil
    else
      'default'
    end

  end

  # Добавить поле с изображением

  def link_to_add_fields(path, name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("/admin/#{path}/" + association.to_s.singularize + "_fields", f: builder)
    end
    link_to('<span class="glyphicon glyphicon-plus"></span> Добавить файл!'.html_safe, '#add_photo_field', class: "btn btn-warning add_field", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def outer_will_paginate model
    will_paginate model, params: { anchor: 'comments' }, class: 'outer-pagination',  inner_window: '2', outer_window: '3'
  end

end