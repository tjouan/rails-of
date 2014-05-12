require 'spec_helper'

feature 'Data files file' do
  scenario 'creates data file' do
    visit new_data_file_path

    fill_in 'Label', with: 'some file'
    attach_file 'Fichier', File.expand_path(fixture_path, 'sample_0.csv').to_s
    click_button 'Enregistrer'
    click_link 'some file'

    # FIXME: capybara won't set the correct content_type and file_name will be
    # hardcoded to `fixtures'
    # https://github.com/jnicklas/capybara/issues/1236
    #expect(page.body).to include 'text/csv'
    expect(page.body).to include 'fixtures'
  end
end
