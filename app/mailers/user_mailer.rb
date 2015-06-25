class UserMailer < ActionMailer::Base

  default from: "\"DandyGame\" <info@dandygame.ru>"

  def signup_request user

    @user = user

    mail to: user.email,
         subject: "Подтверждение регистрации."

  end

  def remember_password_request user

    @user = user

    mail to: user.email,
         subject: "Запрос на установку нового пароля."

  end


  def email_request user

    @user = user

    mail to: user.new_email,
         subject: "Запрос на установку нового e-mail'а."

  end

  def new_comment user, comment, day

    @user    = user
    @comment = comment
    @day     = day

    mail to: user.email,
        subject: "Вам ответили!"

  end


  def new_day user, mytrainings

    puts user.email

    @user        = user
    @mytrainings = mytrainings
    @hello       = 'Доброе утро!'

    if @mytrainings.count == 1
      subject = "Новый день онлайн-тренинга стал доступным!"
    else
      subject = "Новые дни онлайн-тренингов стали доступными!"
    end

    mail to: user.email, subject: subject


  end




  def new_day_report count, emails


    @emails = emails

    mail to: 'info@dandygame.ru',
         subject: "Сегодня было отправлено #{count} " +
             Russian.p(count, 'уведомление!', 'уведомления!', 'уведомлений!')
  end



  def my_message user

    puts user.email

    mail to: user.email,
         subject: "Встреча участников DandyGame СЕГОДНЯ в самом центре Москвы!"

  end


  def test

    puts 'Высылаем тест!'

    mail to: 'info@dandygame.ru',
         subject: "Тест рассыльщика!" do |format|
           format.text { render text: "Если письмо пришло, значит тест пройден!" }
         end

  end


end
