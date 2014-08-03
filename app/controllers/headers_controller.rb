class HeadersController < ApplicationController
  before_action :set_source, only: :edit

  def edit
  end


  private

  def set_source
    @source = current_user.sources.find params[:source_id]
  end
end
