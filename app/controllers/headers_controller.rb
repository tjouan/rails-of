class HeadersController < ApplicationController
  before_action :set_source, only: :new

  def new
    @source.detect_headers! names: @source.file_header
  end

  private

  def set_source
    @source = Source.find(params[:source_id])
  end
end
