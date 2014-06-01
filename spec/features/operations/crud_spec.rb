require 'spec_helper'

feature 'Operations CRUD' do
  let(:operation) { build(:operation) }

  before { operation.save! }

  scenario 'lists operations' do
    visit root_path
    click_link 'Analyses'

    expect(page.body).to include operation.name
  end

  scenario 'shows operation' do
    visit operations_path
    click_link operation.name

    expect(page.body).to include operation.name
  end
end
