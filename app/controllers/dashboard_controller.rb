class DashboardController < ApplicationController
  def show
    @works      = current_user.works.latest
    @operations = Operation.all
  end
end
