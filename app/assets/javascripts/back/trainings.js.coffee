# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->



  # Каталог треннигов. Смена веса тренинга.
  if $('form.weight').length > 0
    $('body').delegate 'form.weight', 'change', () ->

      valuesToSubmit = {
        id:     $(this).find('#training_id').attr('value'),
        weight: $(this).find('#training_weight option:selected').html(),
      }

      $.ajax({
        type: "POST",
        url: $(this).attr('action'),
        data: valuesToSubmit,
      }).success () ->
        location.reload()

      return false





  # Краткое описание тренинга - Code Mirror
  if $('#training_min_description').length > 0


    code_mirror = CodeMirror.fromTextArea document.getElementById('training_min_description'), {
      # readOnly: true,
      mode: "text/html",
      theme: 'base16-light',
      extraKeys: {"Cmd-/": "autocomplete"},
      styleActiveLine: true,
      lineNumbers: true,
      lineWrapping: true,
      extraKeys:
        "Cmd-.": (code_mirror) ->
          code_mirror.setOption "fullScreen", !code_mirror.getOption("fullScreen")
          return

        Esc: (code_mirror) ->
          code_mirror.setOption "fullScreen", false
          return

    }

    code_mirror.setSize(848, 140)

    insert_text_count = (code_mirror) ->

      text_count = code_mirror.getValue().length
      max_count = 180

      $('.min_description_count').html( text_count + " из " + max_count)

      if text_count > max_count
        $('.min_description_count').removeClass('green')
        $('.min_description_count').addClass('red')
      else
        $('.min_description_count').removeClass('red')
        $('.min_description_count').addClass('green')

    insert_text_count(code_mirror)

    code_mirror.on 'change', (code_mirror) ->
      insert_text_count(code_mirror)






    #    insert_text_count = (cm) ->
    #      console.log cm.getValue().length
    #
    #    code_mirror.on 'change', (cm) ->
    #      insert_text_count(cm)
    #
    #insert_text_count()






  # Code Mirror
  #  if $('#training_description').length > 0
  #
  #    code_mirror = CodeMirror.fromTextArea document.getElementById('training_description'), {
  #      # readOnly: true,
  #      mode: "text/html",
  #      theme: 'base16-light',
  #      extraKeys: {"Cmd-/": "autocomplete"},
  #      styleActiveLine: true,
  #      lineNumbers: true,
  #      lineWrapping: true,
  #      extraKeys:
  #        "Cmd-.": (code_mirror) ->
  #          code_mirror.setOption "fullScreen", !code_mirror.getOption("fullScreen")
  #          return
  #
  #        Esc: (code_mirror) ->
  #          code_mirror.setOption "fullScreen", false
  #          return
  #
  #    }
  #    code_mirror.setSize(848, 600)



  if $('#training_description').length > 0
    CKEDITOR.replace( 'training_description' );




  # Code Mirror
  if $('#training_html').length > 0

    code_mirror = CodeMirror.fromTextArea document.getElementById('training_html'), {
      mode: { name: "htmlmixed" },
      theme: 'base16-light',
      extraKeys: {"Cmd-/": "autocomplete"},
      styleActiveLine: true,
      lineNumbers: true,
      lineWrapping: true,
      extraKeys:
        "Cmd-.": (code_mirror) ->
          code_mirror.setOption "fullScreen", !code_mirror.getOption("fullScreen")
          return

        Esc: (code_mirror) ->
          code_mirror.setOption "fullScreen", false
          return

    }
    code_mirror.setSize(848, 150)


  # Code Mirror
  if $('#training_css').length > 0

    code_mirror = CodeMirror.fromTextArea document.getElementById('training_css'), {
      mode: { name: "htmlmixed" },
      theme: 'base16-light',
      extraKeys: {"Cmd-/": "autocomplete"},
      styleActiveLine: true,
      lineNumbers: true,
      lineWrapping: true,
      extraKeys:
        "Cmd-.": (code_mirror) ->
          code_mirror.setOption "fullScreen", !code_mirror.getOption("fullScreen")
          return

        Esc: (code_mirror) ->
          code_mirror.setOption "fullScreen", false
          return

    }
    code_mirror.setSize(848, 600)