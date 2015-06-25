$ ->

  if $('.training-actions .way').length > 0

    training_id = $('.training-actions .progress').data('training')
    day_id      = $('.training-actions .progress').data('day')
    second      = $('.training-actions .progress').data('second') # Сколько секунд до следующего дня

    day    = 86400 # секунд в дне
    step   = 864   # 1 процент/шаг в прогресс баре
    bounce = 5     # Отскок прогресс бара в процентах

    # размер анимации в процентах по короткому пути или реальный размер
    min_way = parseFloat(((86400 - second) / step).toFixed(2))

    # размер отскока если он превышает общую длинну пути
    if (min_way + bounce) <= (100 - bounce)
      big_way = min_way + bounce
    else
      big_way = min_way + ((100 - min_way) / 2)

    duration = 1000

    # Анимация шкалы
    $('.training-actions .way')
      .animate({ opacity: 1 },           queue: false, duration: duration)
      .animate({width: big_way + '%'},   queue: true,  duration: duration)
      .animate({width: min_way + '%'}, queue: true,  duration: duration / 3)


    # Таймер
    $('.training-actions .progress .time-left')
      .countdown({until: second, compact: true, format: 'HMS', description: '', onExpiry: () ->
        location.reload()
      })


    # Продвижение шкалы каждый 1% от 24 часов
    intervalID = setInterval () ->
      $('.training-actions .way').animate({ width: '+=1%' },   queue: true,  duration: duration)

      if parseFloat($('.training-actions .way')[0].style.width) >= 100
        clearInterval(intervalID)
        location.reload()

    , 864000