module DaysHelper


  def day_pagination_line_class(number)

    if @current_user and @mytraining.added?
      'selected' if number < @mytraining.day_number
    end

  end




  def day_pagination_class(number)

    css_class = ''


    # Дни к которым есть доступ
    if @current_user and @mytraining.added? and number <= @mytraining.day_number

      css_class = 'passed'

    end

    # Выбранный день
    if pagination_day_is_selected?(number)

      css_class = 'selected'

    end


    # Выбранный день к которому еще нет доступа
    if controller_name == 'days' and number == params[:id].to_i

      if @current_user and @mytraining.added? and number > @mytraining.day_number
        css_class = 'selected_no_access'
      end

      if @current_user and @mytraining.new?
        css_class = 'selected_no_access'
      end

      unless @current_user
        css_class = 'selected_no_access'
      end



    end


    css_class

  end



  def about_training_pagination_class

    if (controller_name == 'trainings')

      'selected'

    end

  end


  def pagination_day_is_selected?(number)

    case controller_name

      when 'trainings'

        if number == 0
          return true

        end

      when 'days'

        if number == params[:id].to_i
          return true
        end

     false

    end


  end

end
