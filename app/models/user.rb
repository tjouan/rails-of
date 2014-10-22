class User < ActiveRecord::Base
  has_secure_password

  has_many :sources
  has_many :subscriptions
  has_many :works

  validates :email,     presence: true, uniqueness: true
  validates :password,  length: { minimum: 8 }, if: :password_digest_changed?

  before_create :set_activation_token


  def to_s
    '#%d <%s> %s' % [id, email, name]
  end

  def activate!
    update! active: true
  end

  def current_subscription
    subscriptions.last
  end

  def current_subscription_usage
    current_subscription.usage
  end

  def current_subscription_quota
    current_subscription.quota
  end

  def current_subscription_description
    current_subscription.offer.description
  end

  def quota_exceeded?
    current_subscription.quota_exceeded?
  end


  private

  def set_activation_token
    self.activation_token = SecureRandom.urlsafe_base64
  end
end
