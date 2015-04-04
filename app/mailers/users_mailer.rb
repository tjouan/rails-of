class UsersMailer < ActionMailer::Base
  include Backburner::Performable

  default from: 'user+from@optifront.example'

  def welcome(user_id)
    @user = User.find(user_id)
    mail(
      to: @user.email,
      subject: 'Bienvenue sur OptiFront !'
    ).deliver
  end
end
