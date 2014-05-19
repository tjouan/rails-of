require 'spec_helper'

feature 'Data files file' do
  scenario 'creates data file' do
    visit new_data_file_path

    fill_in 'Label', with: 'some file'
    attach_file 'Fichier', File.join(fixture_path, 'sample_0.csv').to_s
    click_button 'Enregistrer'
    click_link 'some file'

    expect(page.body).to include 'sample_0.csv'
    expect(page.body).to include 'text/csv'
  end
end
