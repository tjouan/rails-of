module AcceptanceHelpers
  def create_source(header: false)
    visit new_source_path
    if header
      check 'en-tête'
    else
      uncheck 'en-tête'
    end
    attach_file 'source_file', File.join(fixture_path, '3col_header.csv')
    click_button 'Enregistrer'
  end
end
