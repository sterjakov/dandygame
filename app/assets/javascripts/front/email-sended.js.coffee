$ ->

  if $('#email-sended').length > 0

    # Список возможных личных кабинетов по доменным именам этих почт
    account = $.emailAccounts( $.trim($('#email-sended').html()) )


    # Если есть совпадение из списка
    if account['domain'] && account['url']

      # Вставляем кнопку для перехода в почтовый акаунт
      $('<a href="' + account['url'] + '" class="button blue">Перейти на почту – ' + account['domain'] + '</a>')
      .insertAfter('#email-sended')
