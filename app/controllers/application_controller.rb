class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate!
  before_filter :set_locale

  helper_method :current_user, :current_user?

  def current_user
    @current_user ||= (User.find_by_id(session[:user_id]) if session[:user_id])
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
    redirect_to signin_path signin_path_params unless current_user
  end

  def signin_path_params
    if redirect_path_after_authentication? request.fullpath
      { path: request.fullpath }
    else
      nil
    end
  end

  def redirect_path_after_authentication?(path)
    not [root_path, signin_path, signout_path].include? path
  end

  def set_locale
    I18n.locale = :fr unless Rails.env.test?
  end
end
