class UserForm < FormBase
  resource User

  delegate_attributes %i[
    id email password password_confirmation
    name company tel_number
    subscriptions
  ]

  validates :name,  presence: true
  validates :terms, acceptance: true

  attr_accessor :terms
end
