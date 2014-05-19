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
    @source = Source.new(source_params)

    if @source.save
      if @source.mime_type
        redirect_to edit_source_header_path(@source)
      else
        redirect_to sources_path
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
    @source.destroy
    redirect_to sources_path
  end

  private

  def set_source
    @source = Source.find(params[:id])
  end

  def source_params
    p = params.require(:source).permit(:label, :description, :file, :header)
    p[:header] = p[:header].to_i == 1 ? {} : nil
    p
  end
end
