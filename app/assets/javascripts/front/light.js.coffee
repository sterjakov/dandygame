$ ->

  if $('#comment-id').length > 0

    id = $('#comment-id').val()

    $('.comment[data-id=' + id + '] .description p').css({ color: '#71b801' })
    $('.comment[data-id=' + id + '] .description p').animate({ color: '#71b801' }, 1000).delay(2000).animate({ color: '#000000' }, 1000)

  if $('#feedback-id').length > 0

    id = $('#feedback-id').val()

    $('.feedback[data-id=' + id + '] .description p').css({ color: '#71b801' })
    $('.feedback[data-id=' + id + '] .description p').animate({ color: '#71b801' }, 1000).delay(2000).animate({ color: '#000000' }, 1000)

