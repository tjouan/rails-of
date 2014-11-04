module AcceptanceHelpers
  def sign_in(user = nil)
    @_current_user ||= (user or create :user)
    visit signin_path
    fill_in 'Adresse mail', with: current_user.email
    fill_in 'Mot de passe', with: current_user.password
    click_button 'Connexion'
  end

  def sign_in_with_subscribed_user
    sign_in create :subscribed_user
  end

  def current_user
    @_current_user
  end

  def create_source(file: 'mydata.csv', header: true)
    @_uploaded_source_file_path = uploaded_source_path file

    visit new_source_path
    if header
      check 'file_header'
    else
      uncheck 'file_header'
    end
    attach_file 'source_file', @_uploaded_source_file_path
    click_button 'Enregistrer'
  end

  def uploaded_source_file
    File.new(@_uploaded_source_file_path)
  end

  def click_icon(text)
    find(:xpath, "//a/svg[@alt='#{text}']/..").click
  end


  private

  def uploaded_source_path(file_name)
    File.join(fixture_path, file_name)
  end
end
