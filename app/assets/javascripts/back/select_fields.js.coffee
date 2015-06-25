$ ->


  hide_child_selectable = () ->
    $('.selectable.child').addClass('hidden')

  if $('.selectable.child option:selected').html() == undefined
    hide_child_selectable()

  $('.selectable.parent').change () ->

    id = $(this).find('option:selected').attr('value')
    url = $(this).find('select').attr('data-url').replace(':id', id)

    $.ajax(url, {
      success: (data) ->
        if data == 'false'
          $('.selectable.child').addClass('hidden') unless $('.selectable.child').hasClass('hidden')
          $('.selectable.child select').html(false)
        else
          $('.selectable.child div').html(data)
          $('.selectable.child').removeClass('hidden')
    })
