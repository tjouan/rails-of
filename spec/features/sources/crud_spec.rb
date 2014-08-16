require 'spec_helper'

feature 'Sources CRUD' do
  include AcceptanceHelpers

  background do
    sign_in
    create_source
  end

  scenario 'destroys source' do
    click_icon 'Delete'

    expect(current_path).to eq sources_path
    expect(page).not_to have_content 'mydata'
  end
end
