# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def signup_request

    UserMailer.signup_request

  end

  def new_day

    user = User.find(22)
    UserMailer.new_day(user, user.mytraining.where(status: 0))

  end

end
