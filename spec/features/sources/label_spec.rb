require 'spec_helper'

feature 'Sources label' do
  let(:file_path) { File.join(fixture_path, '3col_header.csv') }

  before do
    visit new_source_path
    attach_file 'source_file', file_path
    click_button 'Enregistrer'
  end

  context 'creation' do
    scenario 'assigns a default label as the attached file name' do
      expect(page).to have_content '3col_header.csv'
    end
  end
end
