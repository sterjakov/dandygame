$ ->

  if $('#comments').length > 0


    # Клик по ссылке "ответить"
    $('body').delegate '.edit', 'click', () ->

      # Закрываем все открытые формы редактирования
      if $('.comment .edit-form form').length > 0

        $('.comment .description').removeClass('hidden')
        $('.comment .edit-form').html('')
        $('.comment .edit').removeClass('hidden')
        $('.comment .cancel').addClass('hidden')

      id_training    = gon.training_id
      id_day         = gon.day_id
      id_comment     = parseInt $(this).parents('.comment').attr('data-id')
      session_token  = $('.comment.first form input[name="authenticity_token"]').val()
      edit_content   = $.trim( $(this).parents('.header').siblings('.description').children('p').html() )

      # Форма ответа
      form = "<form accept-charset='UTF-8' action='/trainings/" + id_training + "/days/" + id_day + "/comments/" + id_comment +  "' class='new_comment' id='new_comment' method='post'>
                <div style='display:none'>
                  <input name='utf8' type='hidden' value='✓'>
                  <input name='_method' type='hidden' value='patch'>
                  <input name='authenticity_token' type='hidden' value='" + session_token + "'>
                  <input class='hidden' name='commit' type='submit' value=''>
                </div>
                <textarea class='noselect' id='comment_description' name='comment[description]'>" + edit_content + "</textarea>
                <div class='actions'>
                  <a class='button orange min all-width submit'>
                    Сохранить ответ!
                  </a>
                </div>
              </form>"

      $(this).parents('.header').siblings('.edit-form').html(form)
      $(this).addClass('hidden')
      $(this).siblings('.cancel').removeClass('hidden')
      $(this).parents('.header').siblings('.description').addClass('hidden')



    # Клик по ссылке "отмена"
    $('body').delegate '.cancel', 'click', () ->

      # Закрыть открытые комментарии если есть
      if $('.comment .edit-form form').length > 0

        $(this).parents('.header').siblings('.description').removeClass('hidden')
        $(this).parents('.header').siblings('.edit-form').html('')
        $(this).addClass('hidden')
        $(this).siblings('.edit').removeClass('hidden')









