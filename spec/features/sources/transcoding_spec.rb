require 'spec_helper'

feature 'Sources file transcoding' do
  include AcceptanceHelpers

  background do
    sign_in
    create_source file: 'mydata_latin1.csv'
    click_icon 'Preview'
  end

  scenario 'transcode iso-8859-15 charset' do
    expect(page.all('.sources-preview th').map(&:text).last).to eq 'activé'
  end
end
