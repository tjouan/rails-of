class UsersMailer < ActionMailer::Base
  include Backburner::Performable

  default from: 'alexis@datacube.fr'

  def welcome(user_id)
    @user = User.find(user_id)
    mail(
      to: @user.email,
      subject: 'Bienvenue sur DATACUBE !'
    ).deliver
  end
end
