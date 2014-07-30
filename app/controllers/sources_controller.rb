class SourcesController < ApplicationController
  before_action :set_source, only: [:show, :edit, :update, :destroy]

  def index
    @sources = Source.all
  end

  def show
  end

  def new
    @source = Source.new
  end

  def edit
  end

  def create
    @source = Source.new(source_params.except :file)

    if SourceSaver.new(@source, source_params[:file]).call
      redirect_to edit_source_headers_path(@source)
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
    @source.destroy
    redirect_to sources_path
  end


  private

  def set_source
    @source = Source.find(params[:id])
  end

  def source_params
    params.require(:source).permit(:label, :description, :file, :file_header, {
      headers_attributes: [:id, :position, :name, :type]
    })
  end
end
