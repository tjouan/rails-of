class HeadersController < ApplicationController
  before_action :set_data_file, only: :edit

  def edit
  end

  private

  def set_data_file
    @data_file = DataFile.find(params[:data_file_id])
  end
end
