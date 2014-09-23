class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate!
  before_filter :register!
  before_filter :set_locale

  helper_method :current_user, :current_user?

  def current_user
    @current_user ||= (User.find(session[:user_id]) if session[:user_id])
  end

  def current_user=(user)
    @current_user     = user
    session[:user_id] = user.id
  end

  def current_user?
    !!current_user
  end


  private

  def authenticate!
    redirect_to signin_path path: request.fullpath unless current_user
  end

  def register!
    return if !current_user? ||
      params[:controller] == 'registrations' ||
      (params[:controller] == 'sessions' && params[:action] == 'destroy')

    if current_user.name.nil?
      flash[:error] = t 'registration.required'
      redirect_to edit_user_registration_path current_user
    end
  end

  def set_locale
    I18n.locale = :fr unless Rails.env.test?
  end
end
