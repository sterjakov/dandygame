$ ->

  # Загрузить файл
  $('body').delegate '.share_file', 'click', ->
    $(this).siblings('.file_input').click()




  # Когда файл загружен
  $('body').delegate '.file_input', 'change', () ->

    if this.files and this.files[0]

      $(this).siblings('.form-control').attr('placeholder',this.files[0]['name'])



  # Добавить поле
  $('body').delegate '.add_field', 'click', (event) ->

    time = new Date().getTime() # получаем метку времени UNIX которую потом азменяем на ID - 1369036309542
    regexp = new RegExp($(this).data('id'), 'g') # формируем строку с регулярным выражением - /95443790/g
    $(this).before($(this).data('fields').replace(regexp, time)) # вставляем перед ссылкой содержание аттрибута data-fields

    event.preventDefault()




  # Удалить поле
  hide_speed = 200   # скорость затухания

  $('body').delegate '.remove_field', 'click', (event) ->

    $(this).siblings('.destroy').val('1')
    $(this).closest('.file-field').fadeOut(hide_speed)
    $(this).parent('div').removeClass('field')

    event.preventDefault()


  true