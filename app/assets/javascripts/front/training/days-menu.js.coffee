$ ->


  # Меню дней тренинга в виде списка
  $('#day_number').change () ->
    select_number = $('#day_number option:selected').val()

    if select_number > 0
      window.location = '/trainings/' + gon.training_id + '/days/' + select_number + '#day_name'
    else
      window.location = '/trainings/' + gon.training_id + '#training_name'
