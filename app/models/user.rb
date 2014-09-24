class User < ActiveRecord::Base
  has_secure_password

  has_many :sources
  has_many :works

  validates :email,     presence: true, uniqueness: true
  validates :password,  length: { minimum: 8 }, if: :password_digest_changed?
  validates :activation_token, presence: true

  before_create :set_activation_token


  def to_s
    '#%d <%s> %s' % [id, email, name]
  end

  def activate!
    update! active: true
  end


  private

  def set_activation_token
    self.activation_token = SecureRandom.urlsafe_base64
  end
end
