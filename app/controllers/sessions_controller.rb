class SessionsController < ApplicationController
  skip_before_filter :authenticate!, only: %i[new create]

  def new
    @path = params[:path]
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user.try(:authenticate, params[:session][:password])
      flash[:notice] = 'Bienvenue %s' % user.name if user.name
      self.current_user = user
      redirect_to params[:session][:path] || dashboard_path
    else
      flash[:error] = t 'authent.invalid'
      render 'new'
    end
  end

  def destroy
    reset_session
    redirect_to :root
  end
end
