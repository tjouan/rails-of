class Users::ActivationsController < ApplicationController
  skip_before_filter :authenticate!

  def activate
    user = User.find_by_activation_token(params[:token])
    user.activate!
    flash[:notice] = <<-eoh
Merci d'avoir confirmé votre adresse mail, votre compte est activé.
    eoh
    if current_user
      redirect_to dashboard_path
    else
      redirect_to signin_path
    end
  end
end
