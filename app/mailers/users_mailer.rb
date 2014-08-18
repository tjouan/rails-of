class UsersMailer < ActionMailer::Base
  include Backburner::Performable

  default from: 'contact@datacube.fr'

  def welcome(user_id)
    @user = User.find(user_id)
    mail(
      to: @user.email,
      subject: 'Bienvenue sur OptiDM !'
    ).deliver
  end
end
