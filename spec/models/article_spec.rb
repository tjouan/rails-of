require 'spec_helper'

describe Article do
  subject(:article) { build :article }

  it 'is valid' do
    expect(article).to be_valid
  end

  it 'validates presence of the zone' do
    expect(article).to validate_presence_of :zone
  end

  it 'validates presence of the body' do
    expect(article).to validate_presence_of :body
  end
end
