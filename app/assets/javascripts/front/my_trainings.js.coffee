# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  if $('.my-training').length > 0

    # Показать спрятать скрытые тренинги
    $('.show-hidden').click () ->

      $('.hidden-trainings').removeClass('hidden')
      $('.show-hidden').addClass('hidden')

    $('.hide-hidden').click () ->

      $('.hidden-trainings').addClass('hidden')
      $('.show-hidden').removeClass('hidden')


    # Анимация шкалы прогресса при загрузке страницы

    set_way = (place) ->

      place = place.children('.offset').children('.way')

      duration = 1000

      day  = place.data('day')
      days = place.data('days')

      step = 100 / days
      final_way = step * day

      big_way   = final_way + step

      if (final_way + step) <= 100
        big_way   = final_way + step
      else
        big_way   = final_way + (100 - final_way) / 2


      place
        .animate({ opacity: 1 },           queue: false, duration: duration)
        .animate({width: big_way + '%'},   queue: true,  duration: duration)
        .animate({width: final_way + '%'}, queue: true,  duration: duration / 3)


    $('.animation-way').each( () ->
      set_way($(this))
    )
