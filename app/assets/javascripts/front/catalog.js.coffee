$ ->

  if gon.device_type == 'desktop'


    if $('.animation-line-flare').length > 0

      speed = 200

      $('.catalog .place.animation-line-flare').hover () ->

        width = $('.line-flare').parent().width()

        $(this).children('.offset').children('.line-flare').stop().animate { marginLeft: width + 'px' }, 400

        $(this).find('.front').animate { opacity: 0 }, { queue: false, duration: speed, complete: ->
          $(this).addClass 'hidden'
          $(this).siblings('.back').removeClass('hidden')
          $(this).siblings('.back').animate { opacity: 1 } , speed
        }

      , () ->

        width = $('.line-flare').width()

        $(this).children('.offset').children('.line-flare').stop().animate { marginLeft: '-' + width + 'px' }, 400

        $(this).find('.back').animate { opacity: 0 }, { queue: false, duration: speed, complete: ->
          $(this).addClass 'hidden'
          $(this).siblings('.front').removeClass('hidden')
          $(this).siblings('.front').animate { opacity: 1 } , speed
        }


    if $('.animation-circles-flare').length > 0

      speed = 1000
      delay = 400

      $('.catalog .place.animation-circles-flare').hover () ->

        target = $(this).children('.offset').children('.circles-flare-1')

        runIt = (target) ->

          if $(target).parent('.offset').parent('.animation-circles-flare').is(':hover')

            $(target).stop().animate { opacity: 1 }, speed, () ->
              $(this).animate { opacity: 0 }, speed
              $(this).siblings('.circles-flare-2').stop().delay(delay).animate { opacity: 1 }, speed, () ->
                $(this).animate { opacity: 0 }, speed
                $(this).siblings('.circles-flare-3').stop().delay(delay).animate { opacity: 1 }, speed, () ->
                  $(this).animate { opacity: 0 }, speed
                  setTimeout () ->
                    runIt(target)
                  , delay


        runIt(target)

      , () ->

        $('.circles-flare-1').stop(true).animate { opacity: 0 }, speed
        $('.circles-flare-2').stop(true).animate { opacity: 0 }, speed
        $('.circles-flare-3').stop(true).animate { opacity: 0 }, speed

        $(this).parent('.offset').parent('.animation-circles-flare').stop(true).animate { opacity: 0 }, speed


#    if $('.animation-circles-flare').length > 0
#
#      speed = 700
#      delay = 300
#
#      $('body').delegate '.catalog .place.animation-circles-flare', 'mouseenter mouseleave', (event) ->
#
#        if event.type == 'mouseenter'
#
#          console.log event.type
#
#          target = $(this).children('.offset').children('.circles-flare-1')
#
#          runIt = (target) ->
#
#            $(target).stop().animate { opacity: 1 }, speed, () ->
#              $(this).animate { opacity: 0 }, speed
#              $(this).siblings('.circles-flare-2').stop().delay(delay).animate { opacity: 1 }, speed, () ->
#                $(this).animate { opacity: 0 }, speed
#                $(this).siblings('.circles-flare-3').stop().delay(delay).animate { opacity: 1 }, speed, () ->
#                  $(this).animate { opacity: 0 }, speed
#                  setTimeout () ->
#                    runIt(target)
#                  , delay
#
#          runIt(target)
#
#
#        if (event.type == 'mouseleave')
#
#          $('.circles-flare-1').stop().animate { opacity: 0 }, speed
#          $('.circles-flare-2').stop().animate { opacity: 0 }, speed
#          $('.circles-flare-3').stop().animate { opacity: 0 }, speed
#
#          $(target).stop().animate { opacity: 0 }, speed




    if $('.animation-size').length > 0

      $('body').delegate '.catalog .place.animation-size', 'mouseenter mouseleave', (event) ->

        if event.type == 'mouseenter'

          $(this).children('.offset').children('.system').stop().animate({ width: '250px', height: '93px', marginTop: '18px' })

        if event.type == 'mouseleave'

          $(this).children('.offset').children('.system').stop().animate({ width: '215px', height: '80px', marginTop: '25px' })









