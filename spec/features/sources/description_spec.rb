require 'spec_helper'

feature 'Sources description' do
  include AcceptanceHelpers

  before { create_source }

  scenario 'associates description to a source' do
    visit sources_path

    click_link 'Modifier'
    fill_in 'Description', with: 'some description'
    click_button 'Enregistrer'
    click_link '3col_header'

    expect(page).to have_content 'some description'
  end
end
