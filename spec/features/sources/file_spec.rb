require 'spec_helper'

feature 'Sources file' do
  def create_new_source_with_file
    visit new_source_path
    fill_in 'Label', with: 'some file'
    attach_file 'source_file', File.join(fixture_path, '3col_header.csv').to_s
    click_button 'Enregistrer'
  end

  scenario 'creates source with attached file' do
    create_new_source_with_file
    visit sources_path
    click_link 'some file'

    expect(page.body).to include '3col_header.csv'
    expect(page.body).to include 'text/csv'
  end

  scenario 'redirects to header edit' do
    create_new_source_with_file
    expect(current_path).to eq edit_source_header_path(Source.last)
  end
end
