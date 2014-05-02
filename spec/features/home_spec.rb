require 'spec_helper'

feature 'Home page' do
  scenario 'displays home message'do
    visit root_path

    expect(page).to have_content 'OptiDM'
  end
end
