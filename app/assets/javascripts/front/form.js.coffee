$ ->

  $('body').delegate '.radio-button', 'click', () ->
    $(this).find('input[type=radio]').prop('checked', true);

  $('body').delegate 'form .submit', 'click', () ->
    $(this).parents('form').submit()

