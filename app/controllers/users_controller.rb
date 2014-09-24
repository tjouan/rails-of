class UsersController < ApplicationController
  skip_before_filter :authenticate!, only: %i[new create]

  def new
    @user = UserForm.new(params[:user] ? user_params : {})
  end

  def create
    @user = UserForm.new(user_params)

    if UserCreater.new(@user).call
      self.current_user = @user.object
      flash[:notice] = 'Bienvenue sur Datacube !'
      redirect_to dashboard_path
    else
      render :new
    end
  end


  private

  def user_params
    params.require(:user)
      .permit(%i[
        email password password_confirmation
        name company tel_number terms
      ])
  end
end
