class PreviewsController < ApplicationController
  def show
    @source = current_user.sources.find params[:source_id]
  end
end
