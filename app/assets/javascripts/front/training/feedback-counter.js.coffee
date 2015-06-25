$ ->

  if $('.feedback_counter').length > 0

    max_count = parseInt( $('.symbol_counter .number').html() )

    $('.feedback_counter textarea').on 'input propertychange', () ->

      feedback_length = max_count - $(this).val().length

      if feedback_length >= 0

        if $('.feedback_counter .symbol_counter').hasClass('hidden')
          $('.feedback_counter .symbol_counter').removeClass('hidden')
          $('.feedback_counter .ready').addClass 'hidden'

        $('.symbol_counter .number').html feedback_length

      else

        if $('.feedback_counter .ready').hasClass('hidden')
          $('.feedback_counter .ready').removeClass 'hidden'
          $('.feedback_counter .symbol_counter').addClass('hidden')


        #if $('.feedback_counter .symbol_counter').hasClass('orange')


