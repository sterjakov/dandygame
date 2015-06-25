$ ->

  if gon.device_type == 'desktop'

    $('.training-head .right a .arrow').mouseenter ->
      $(this).parent('a').stop(true).animate({ paddingLeft: '10px' }, 200).animate({ paddingLeft: '0px' }, 200)

    $('.training-head .left a .arrow').mouseenter ->
      $(this).parent('a').stop(true).animate({ paddingRight: '10px' }, 200).animate({ paddingRight: '0px' }, 200)
