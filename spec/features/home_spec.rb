require 'spec_helper'

feature 'Home page' do
  scenario 'redirects to dashboard'do
    visit root_path

    expect(current_path).to eq dashboard_path
  end
end
