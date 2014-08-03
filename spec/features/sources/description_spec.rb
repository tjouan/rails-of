require 'spec_helper'

feature 'Sources description' do
  include AcceptanceHelpers

  background do
    sign_in
    create_source
  end

  scenario 'associates description to a source' do
    visit sources_path

    click_icon 'Edit'
    fill_in 'Description', with: 'some description'
    click_button 'Enregistrer'
    click_link 'mydata.csv'

    expect(page).to have_content 'some description'
  end
end
