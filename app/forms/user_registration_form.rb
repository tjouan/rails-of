class UserRegistrationForm < FormBase
  resource User

  delegate_attributes %i[id name]

  validates :name,  presence: true
  validates :terms, acceptance: true

  attr_accessor :terms
end
