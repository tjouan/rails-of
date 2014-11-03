class ExportsController < ApplicationController
  before_action :set_source
  before_action :set_export, only: %i[show destroy]

  def index
    @exports = @source.exports
  end

  def show
    send_file @export.path, type: 'text/csv', filename: @export.file_name
  end

  def new
    @export = @source.exports.new
  end

  def create
    @export = @source.exports.new export_params

    if ExportSaver.new(@export).call
      redirect_to source_exports_path @source
    else
      render :new
    end
  end

  def destroy
    ExportDestroyer.new(@export).call
    redirect_to source_exports_path @source
  end


  private

  def set_source
    @source = current_user.sources.find params[:source_id]
  end

  def set_export
    @export = @source.exports.find params[:id]
  end

  def export_params
    params.require(:export)
      .permit %i[source_id header charset separator file_name]
  end
end
