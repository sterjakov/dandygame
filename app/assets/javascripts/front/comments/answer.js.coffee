$ ->

  if $('#comments').length > 0


    # Клик по ссылке "ответить"
    $('body').delegate '.answer', 'click', () ->

      # Закрываем все открытые формы ответа
      if $('.comment .answer-form form').length > 0

        $('.comment .answer-form').html('')
        $('.comment .header .answer').removeClass('hidden')
        $('.comment .header .cancel').addClass('hidden')

      id_training    = gon.training_id
      id_day         = gon.day_id
      id_comment     = parseInt $(this).parents('.comment').attr('data-id')
      session_token  = $('.comment.first form input[name="authenticity_token"]').val()

      # Форма ответа
      form = "<form accept-charset='UTF-8' action='/trainings/" + id_training + "/days/" + id_day + "/comments' class='new_comment' id='new_comment' method='post'>
                <div style='display:none'>
                  <input name='utf8' type='hidden' value='✓'>
                  <input name='authenticity_token' type='hidden' value='" + session_token + "'>
                  <input class='hidden' name='commit' type='submit' value=''>
                </div>
                <textarea class='noselect' id='comment_description' name='comment[description]'></textarea>
                <input id='comment_parent_id' name='comment[parent_id]' type='hidden' value='" + id_comment + "'>
                <div class='actions'>
                  <a class='button orange min all-width submit'>
                    Сохранить комментарий!
                  </a>
                </div>
              </form>"

      $(this).parents('.header').siblings('.answer-form').html(form)
      $(this).addClass('hidden')
      $(this).siblings('.cancel').removeClass('hidden')



    # Клик по ссылке "отмена"
    $('body').delegate '.cancel', 'click', () ->

      # Закрыть открытые комментарии если есть
      if $('.comment .answer-form form').length > 0

        $(this).parents('.header').siblings('.answer-form').html('')
        $(this).addClass('hidden')
        $(this).siblings('.answer').removeClass('hidden')









