class Admin::BaseController < ApplicationController
  RESOURCES = [
    Operation,
    Source,
    User,
    Work,
  ].freeze

  before_filter :authorize!


  private

  def authorize!
    fail AbstractController::ActionNotFound unless current_user.admin?
  end
end
