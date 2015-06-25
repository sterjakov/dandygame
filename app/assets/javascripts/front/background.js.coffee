$ ->

  if gon.device_type == 'mobile' or gon.device_type == 'tablet'

    if $('body.default').length > 0

      $('body.default').css({ backgroundAttachment: 'scroll' })

      $(document).scroll () ->

        top_height = $(document).scrollTop() - 100

        $('body.default').stop(true).animate({ backgroundPositionY: top_height }, 1300)