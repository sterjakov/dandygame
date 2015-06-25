$ ->

  $('a').tap (e) ->
    true

  $('a').on 'touchstart' , ->
    $(this).removeClass('no-touch')