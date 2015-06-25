namespace :notifier do


  desc "Тесты рассыльщика"

  task :test => :environment do

    UserMailer.test.deliver()

  end



  desc "Рассылка о доступности новых дней игры"

  task new_day: :environment do

    # Кол-во дней за которые пользователь проявлял любую активность
    active_days = 7

    # Пользователи которые проявляли активность за последние дни
    active_users = User.where(notify_day: 1, confirm: 1, updated_at: ((DateTime.now - active_days.day)..DateTime.now))
    #active_users = User.where(role: 3, updated_at: ((DateTime.now - active_days.day)..DateTime.now))

    i      = 0  # счетчик кол-ва отправленных уведомлений
    emails = [] # email'ы пользователей

    active_users.each do |user|

      mytraining = user.mytraining.where(status: 0)

      if mytraining.count > 0

        if UserMailer.new_day(user, mytraining).deliver
          i      += 1
          emails << user.email
        end

      end


    end

    # Отчет об уведомлениях
    UserMailer.new_day_report(i, emails).deliver()

  end




  desc "Рассылка лично от меня"

  task my_message: :environment do

    # Кол-во дней за которые пользователь проявлял любую активность
    active_days = 300

    # Пользователи которые проявляли активность за последние дни
    active_users = User.where(notify_day: 1, confirm: 1, updated_at: ((DateTime.now - active_days.day)..DateTime.now))
    #active_users = User.where(role: 3, updated_at: ((DateTime.now - active_days.day)..DateTime.now))

    i      = 0  # счетчик кол-ва отправленных уведомлений
    emails = [] # email'ы пользователей

    active_users.each do |user|

      if UserMailer.my_message(user).deliver
        i      += 1
        emails << user.email
      end



    end

    # Отчет об уведомлениях
    UserMailer.new_day_report(i, emails).deliver()

  end



  desc "Рассылка о доступности новых дней игры"

  task new_day_personally: :environment do

    #active_days = 3

    # Пользователи которые проявляли активность за последние дни
    active_users = User.where(id: 1)

    i      = 0  # счетчик кол-ва отправленных уведомлений
    emails = [] # email'ы пользователей

    active_users.each do |user|

      mytraining = user.mytraining.where(status: 0)

      if mytraining.count > 0

        if UserMailer.new_day(user, mytraining).deliver
          i      += 1
          emails << user.email
        end

      end


    end

    # Отчет об уведомлениях
    UserMailer.new_day_report(i, emails).deliver()

  end



end

