class SessionsController < ApplicationController
  skip_before_filter :authenticate!, only: %i[new create]

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user.try(:authenticate, params[:session][:password])
      flash[:notice] = 'Bienvenue %s' % user.name
      self.current_user = user
      redirect_to :root
    else
      flash[:error] = t 'authent.invalid'
      render 'new'
    end
  end
end
