class HomeController < ApplicationController
  skip_before_filter :authenticate!

  def index
    redirect_to dashboard_path and return if current_user?
    @user = User.new
  end
end
