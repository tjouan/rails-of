class Admin::DashboardController < Admin::BaseController
  def show
    @resources = RESOURCES.map { |e| Admin::ModelPresenter.new(e) }
  end
end
