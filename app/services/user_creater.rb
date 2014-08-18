class UserCreater
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    return false unless user.save

    UsersMailer.async.welcome(user.id)

    true
  end
end
