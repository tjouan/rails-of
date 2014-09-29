class UserCreater
  def initialize(user)
    @user = user
  end

  def call
    @user.subscriptions << build_subscription
    @user.save or return false
    UsersMailer.async.welcome(@user.id)

    true
  end


  private

  def build_subscription
    Subscription.new(
      offer: Offer.free_offer,
      start_at: DateTime.now,
      end_at:   Offer::FREE_OFFER_DAY_COUNT.days.from_now
    )
  end
end
