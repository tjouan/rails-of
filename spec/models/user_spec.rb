require 'spec_helper'

describe User do
  subject(:user) { build :user }

  it 'is valid' do
    expect(user).to be_valid
  end

  it 'has secure password' do
    expect(user).to have_secure_password
  end

  it 'validates presence of the email' do
    expect(user).to validate_presence_of :email
  end

  it 'validates uniqueness of the email' do
    expect(user).to validate_uniqueness_of :email
  end

  it 'validates minimum length for the password' do
    expect(user).to ensure_length_of(:password).is_at_least 8
  end
end
