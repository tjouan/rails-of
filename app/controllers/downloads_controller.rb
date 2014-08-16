class DownloadsController < ApplicationController
  def show
    source = current_user.sources.find params[:source_id]
    send_file source.path, type: 'text/csv', filename: source.file_name
  end
end
