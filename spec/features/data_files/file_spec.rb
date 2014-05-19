require 'spec_helper'

feature 'Data files file' do
  def create_new_data_file_with_file
    visit new_data_file_path
    fill_in 'Label', with: 'some file'
    attach_file 'data_file_file', File.join(fixture_path, '3col_header.csv').to_s
    click_button 'Enregistrer'
  end

  scenario 'creates data file with attached file' do
    create_new_data_file_with_file
    visit data_files_path
    click_link 'some file'

    expect(page.body).to include '3col_header.csv'
    expect(page.body).to include 'text/csv'
  end

  scenario 'redirects to header edit' do
    create_new_data_file_with_file
    expect(current_path).to eq edit_data_file_header_path(DataFile.last)
  end
end
