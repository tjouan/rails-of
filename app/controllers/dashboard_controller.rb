class DashboardController < ApplicationController
  def show
    @works      = current_user.works.latest
    @operations = Operation.active
  end
end
