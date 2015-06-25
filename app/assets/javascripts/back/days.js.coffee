# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  if $('#day_description').length > 0
    CKEDITOR.replace( 'day_description' );


  #  if $('#day_description').length > 0
  #
  #    code_mirror = CodeMirror.fromTextArea document.getElementById('day_description'), {
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
  #
  #    code_mirror.doc.setValue $.htmlClean(code_mirror.doc.getValue(), {format:true,});


