class SourcesController < ApplicationController
  before_action :set_source, only: %i[show edit update destroy]

  def index
    @sources = current_user.sources
  end

  def show
  end

  def new
    @source = Source.new
  end

  def edit
  end

  def create
    @source = current_user.sources.new source_params.except :file

    if SourceSaver.new(@source, source_params[:file], params[:file_header]).call
      if params[:file_header]
        redirect_to sources_path
      else
        redirect_to edit_source_headers_path @source
      end
    else
      render :new
    end
  end

  def update
    if @source.update(source_params)
      redirect_to sources_path
    else
      render :edit
    end
  end

  def destroy
    SourceDestroyer.new(@source).call
    redirect_to sources_path
  end


  private

  def set_source
    @source = current_user.sources.find params[:id]
  end

  def source_params
    params.require(:source).permit(:label, :description, :file, {
      headers_attributes: [:id, :position, :name, :type]
    })
  end
end
