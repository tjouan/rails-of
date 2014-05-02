require 'spec_helper'

describe DataFile do
  subject(:data_file) { FactoryGirl.build(:data_file) }

  it 'is valid' do
    expect(data_file).to be_valid
  end
end
