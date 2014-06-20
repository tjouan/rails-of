require 'spec_helper'

feature 'Sources preview' do
  include AcceptanceHelpers

  background do
    create_source
    visit sources_path
    click_link 'Preview'

    visit source_preview_path(Source.last)
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
