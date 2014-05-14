class DataFilesController < ApplicationController
  before_action :set_data_file, only: [:show, :edit, :update, :destroy]

  def index
    @data_files = DataFile.all
  end

  def show
  end

  def new
    @data_file = DataFile.new
  end

  def edit
  end

  def create
    @data_file = DataFile.new(data_file_params)

    if @data_file.save
      if @data_file.mime_type
        redirect_to edit_data_file_header_path(@data_file)
      else
        redirect_to data_files_path
      end
    else
      render :new
    end
  end

  def update
    if @data_file.update(data_file_params)
      redirect_to data_files_path
    else
      render :edit
    end
  end

  def destroy
    @data_file.destroy
    redirect_to data_files_path
  end

  private

  def set_data_file
    @data_file = DataFile.find(params[:id])
  end

  def data_file_params
    p = params.require(:data_file).permit(:label, :description, :file, :header)
    p[:header] = p[:header].to_i == 1 ? {} : nil
    p
  end
end
