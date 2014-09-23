class UserRegistrationForm < FormBase
  resource User

  delegate_attributes %i[id name company tel_number]

  validates :name,  presence: true
  validates :terms, acceptance: true

  attr_accessor :terms
end
