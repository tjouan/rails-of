require 'spec_helper'

feature 'Data files description' do
  scenario 'associates description to a data file' do
    FactoryGirl.create(:data_file, label: 'some file')
    visit data_files_path

    click_link 'Modifier'
    fill_in 'Description', with: 'some description'
    click_button 'Enregistrer'
    click_link 'some file'

    expect(page.body).to include 'some description'
  end
end
