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

  def build_subscription(offer = Offer.free_offer)
    Subscription.new(
      offer:    offer,
      start_at: DateTime.now,
      end_at:   Offer::FREE_OFFER_DAY_COUNT.days.from_now,
      quota:    offer.quota
    )
  end
end
