$ ->

  retina = window.devicePixelRatio > 1;

  if(retina) and $('img.replace-hq').length > 0 and screen.width > 700

    $('img.replace-hq').each () ->

      $(this).attr('src', $(this).data('src-hq'))




