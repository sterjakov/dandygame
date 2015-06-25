module TrainingsHelper


  def parallax_style *args

    bgColor  = args[0][:bgColor]
    bgHeight = args[0][:bgHeight]
    alt      = args[0][:alt]
    layers   = args[0][:layers]

    style = "

      body {
        background-color: #{bgColor};
      }

      #wrapper {
        background-size: auto #{bgHeight}px !important;
        background-position: top;
        background-image: url(/trainings/#{alt}/bg.jpg) !important;
      }

      @media (-webkit-min-device-pixel-ratio: 2) {
        #wrapper {
          background-image: url(/trainings/#{alt}/2x/bg.jpg) !important;
        }
      }

      "

    html = ""
    layers.each do |layer|

      style += "

      .l#{layer[:number]} {
        background-image:url(/trainings/#{alt}/#{layer[:number]}.png);
        background-size: auto #{layer[:bgHeight]}px;
        top: #{layer[:bgTop]}px;
        left: #{layer[:bgLeft]}px;
      }

      @media (-webkit-min-device-pixel-ratio: 2) {
        .l#{layer[:number]} {
          background-image:url(/trainings/#{alt}/2x/#{layer[:number]}.png);
        }
      }

      "

      html += content_tag(:div, nil, class: "parallax l#{layer[:number]}", data: { :"parallaxify-range-x" => layer[:x], :"parallaxify-range-y" => layer[:y] })
    end

    result = content_tag(:style, style) + html.html_safe
    result


  end


  # Отмформатированная цена тренинга
  def human_training_price training
    number_to_currency(training.get_training_price, precision: 0, delimiter: ' ')
  end

  # Кол-во участников треннига для лейбла
  def human_people_count_label training
    if training[:people_count].to_i == 0
      "Стань первым участником!"
    else
      "Уже " + human_training_people_count(training)
    end
  end


  # Отформатированное колличество участников тренинга
  def human_training_people_count training
    count = training[:people_count].to_i

    number_with_precision(count, precision: 0, delimiter: ' ') + " " +
    Russian.p(count, "участник!", "участника!","участников!")

  end

  # Отформатированное колличество дней тренинга
  def human_training_days training
    if training[:day_count] > 0
      training[:day_count] + " " + Russian.p(training[:total_day].to_i, 'день','дня','дней')
    else
      '0 дней'
    end
  end

  # Отформатированное колличество первых бесплатных дней тренинга
  def human_training_free_days training
    count = training[:free_day].to_i

    Russian.p(count, 'Первый','Первые','Первые') + " " +
      ((count == 1) ? nil : count).to_s + " " +
      Russian.p(count, 'день','дня','дней')
  end

end
