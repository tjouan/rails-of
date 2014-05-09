require 'spec_helper'

feature 'Data files file' do
  scenario 'creates data file' do
    visit new_data_file_path

    fill_in 'Label', with: 'some file'
    attach_file 'Fichier', File.expand_path(fixture_path, 'sample_0.csv')
    click_button 'Enregistrer'
    click_link 'some file'

    # FIXME: capybara won't set the correct content_type on attached file.
    # https://github.com/jnicklas/capybara/issues/1236
    #expect(page.body).to include 'text/csv'
  end
end
