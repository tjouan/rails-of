class Admin::BaseController < ApplicationController
  RESOURCES = [
    Operation,
    User
  ].freeze

  before_filter :authorize!


  private

  def authorize!
    fail AbstractController::ActionNotFound unless current_user.admin?
  end
end
