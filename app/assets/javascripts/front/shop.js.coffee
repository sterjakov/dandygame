# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->


  if $('#shop').length > 0

    $('.catalog .price.place').click () ->

      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $('#pay_price').val('')

        $('.robokassa').slideUp()

        $('#order_item_id').attr('value', '')

      else
        $('.catalog .price.place').removeClass('selected')
        $(this).addClass('selected')

        $('#order_item_id').val( $(this).data('id') )
        $('.robokassa').slideDown()

        #$('input[name=OutSum]').attr('value', $(this).data('cost'))
        #$('input[name=SignatureValue]').attr('value', $(this).data('signature-value'))
