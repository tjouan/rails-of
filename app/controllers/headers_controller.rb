class HeadersController < ApplicationController
  before_action :set_source, only: :edit

  def edit
  end


  private

  def set_source
    @source = Source.find(params[:source_id])
  end
end
