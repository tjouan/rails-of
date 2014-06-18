require 'spec_helper'

feature 'Sources description' do
  scenario 'associates description to a source' do
    source = create :source
    visit sources_path

    click_link 'Modifier'
    fill_in 'Description', with: 'some description'
    click_button 'Enregistrer'
    click_link source.label

    expect(page).to have_content 'some description'
  end
end
