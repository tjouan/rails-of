class PreviewsController < ApplicationController
  def show
    @source = Source.find(params[:source_id])
  end
end
