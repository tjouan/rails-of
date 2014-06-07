class SourcesController < ApplicationController
  before_action :set_source, only: [:show, :edit, :update, :destroy, :download]

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
    @source = Source.new(source_params)

    if @source.save
      redirect_to new_source_headers_path(@source, header: params[:header])
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

  def download
    send_file @source.path, type: @source.mime_type, disposition: nil
  end

  private

  def set_source
    @source = Source.find(params[:id])
  end

  def source_params
    params.require(:source).permit(:label, :description, :file, {
      headers_attributes: [:name, :type]
    })
  end
end
