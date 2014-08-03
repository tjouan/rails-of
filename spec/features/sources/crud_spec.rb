require 'spec_helper'

feature 'Sources CRUD' do
  include AcceptanceHelpers

  background { sign_in }

  scenario 'destroys source' do
    create :source, user: current_user
    visit sources_path

    click_icon 'Delete'

    expect(current_path).to eq sources_path
    expect(page).not_to have_content 'some file'
  end
end
