class RegistrationsController < ApplicationController
  def edit
    @user = UserRegistrationForm.new({}, current_user)
  end

  def update
    @user = UserRegistrationForm.new(user_params, current_user)

    if @user.save
      redirect_to dashboard_path
    else
      render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :company, :tel_number, :terms)
  end
end
