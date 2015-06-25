$.emailAccounts = (email) ->

  account = []

  # Список возможных личных кабинетов по доменным именам этих почт
  switch email.split('@')[1]

    when 'bk.ru', 'mail.ru', 'list.ru', 'inbox.ru'
      account['domain'] = 'mail.ru'
      account['url']    = 'https://e.mail.ru/'

    when 'yandex.ru'
      account['domain'] = 'mail.yandex.ru'
      account['url']    = 'https://mail.yandex.ru/'

    when 'gmail.com'
      account['domain'] = 'mail.google.com'
      account['url']    = 'https://mail.google.com/'

    when 'rambler.ru', 'lenta.ru', 'autorambler.ru', 'myrambler.ru', 'ro.ru'
      account['domain'] = 'mail.rambler.ru'
      account['url']    = 'https://mail.rambler.ru/'

    when 'yahoo.com'
      account['domain'] = 'mail.yahoo.com'
      account['url']    = 'https://mail.yahoo.com/'

    when 'hotmail.com', 'outlook.com', 'live.com'
      account['domain'] = 'mail.live.com'
      account['url']    = 'https://mail.live.com/'

    when 'me.com', 'icloud.com'
      account['domain'] = 'icloud.com#mail'
      account['url']    = 'https://www.icloud.com/#mail'

    when 'qip.ru', 'pochta.ru', 'fromru.com', 'front.ru', 'hotbox.ru', 'hotmail.ru', 'krovatka.su', 'land.ru', 'mail15.com', 'mail333.com', 'newmail.ru', 'nightmail.ru', 'nm.ru', 'pisem.net', 'pochtamt.ru', 'pop3.ru', 'rbcmail.ru', 'smtp.ru', '5ballov.ru', 'aeterna.ru', 'ziza.ru','memori.ru', 'photofile.ru', 'fotoplenka.ru', 'pochta.com'
      account['domain'] = 'mail.qip.ru'
      account['url']    = 'https://mail.qip.ru/'

  return account




