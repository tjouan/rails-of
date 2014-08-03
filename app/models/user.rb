class User < ActiveRecord::Base
  has_secure_password

  has_many :sources
  has_many :works

  validates :name,      presence: true
  validates :email,     presence: true, uniqueness: true
  validates :password,  length: { minimum: 8 }
end
