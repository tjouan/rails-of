require 'spec_helper'

feature 'Sources preview' do
  include AcceptanceHelpers

  background do
    sign_in
    create_source
    visit sources_path
    click_icon 'Preview'
  end

  scenario 'shows data preview' do
    expect(page.all('main table tbody td').map(&:text)).to eq %w[
      name  score active
      foo   42    1
      bar   13    1
      baz   32    0
    ]
  end
end
