require 'spec_helper'

feature 'Home page' do
  scenario 'redirects to works/index'do
    visit root_path

    expect(current_path).to eq works_path
  end
end
