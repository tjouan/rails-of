require 'spec_helper'

feature 'Sources description' do
  scenario 'associates description to a source' do
    FactoryGirl.create(:source, label: 'some file')
    visit sources_path

    click_link 'Modifier'
    fill_in 'Description', with: 'some description'
    click_button 'Enregistrer'
    click_link 'some file'

    expect(page.body).to include 'some description'
  end
end
