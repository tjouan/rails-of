class UsersController < ApplicationController
  skip_before_filter :authenticate!, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if UserCreater.new(@user).call
      self.current_user = @user
      flash[:notice] = 'Bienvenue sur Datacube !'
      redirect_to edit_user_registration_path @user
    else
      render :new
    end
  end


  private

  def user_params
    params.require(:user)
      .permit(:name, :email, :password, :password_confirmation)
  end
end
