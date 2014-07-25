class DownloadsController < ApplicationController
  def show
    source = Source.find(params[:source_id])
    send_file source.path, type: source.mime_type, filename: source.file_name
  end
end
