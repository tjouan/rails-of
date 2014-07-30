class DashboardController < ApplicationController
  def show
    @works      = Work.latest
    @operations = Operation.all
  end
end
