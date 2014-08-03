require 'spec_helper'

feature 'Source download' do
  include AcceptanceHelpers

  background do
    sign_in
    create_source
    visit sources_path
    click_icon 'Download'
  end

  scenario 'gets the attached file' do
    expect(page.body).to eq uploaded_source_file.read
  end

  scenario 'sets the source content-type' do
    expect(response_headers['Content-Type']).to eq 'text/csv'
  end
end
