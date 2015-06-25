$ ->

  delay = 1000

  good = $('.notification.good')

  if good.length > 0

    good.slideDown()

    good.animate({ borderColor: '#71b801' }, 1000).delay(delay).animate({ borderColor: 'rgba(255, 255, 255, 0.2)' }, 1000)

    setTimeout ->

      good.slideUp()

      $('.start-free').slideDown()


    , 7000






  bad = $('.notification.bad')

  bad.slideDown()

  if bad.length > 0

    bad.animate({ borderColor: '#e84854' }, 1000).delay(delay).animate({ borderColor: 'rgba(255, 255, 255, 0.2)' }, 1000)

    setTimeout ->
      bad.slideUp()
    , 12000







  trainingHead = $('.training-head .notification')

  if trainingHead.length > 0

    trainingHead.animate({ borderColor: '#71b801' }, 1000).delay(delay).animate({ borderColor: '#f0f0f0' }, 1000)

    setTimeout ->
      trainingHead.slideUp()
    , 15000
