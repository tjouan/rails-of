class Admin::BaseController < ApplicationController
  RESOURCES = [
    Article,
    Offer,
    Operation,
    Source,
    User,
    Work
  ].freeze

  before_filter :authorize!
  before_filter :set_locale


  private

  def authorize!
    fail AbstractController::ActionNotFound unless current_user.admin?
  end

  def set_locale
    I18n.locale = :en
  end
end
