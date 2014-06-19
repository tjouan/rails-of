require 'spec_helper'

feature 'Sources label' do
  include AcceptanceHelpers

  background { create_source }

  context 'creation' do
    scenario 'assigns a default label as the attached file name' do
      expect(page).to have_content '3col_header.csv'
    end
  end
end
