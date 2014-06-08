class WorksController < ApplicationController
  def index
    @works      = Work.all
    @operations = Operation.all
  end

  def new
    @work     = Work.new(operation: Operation.find(params[:operation_id]))
    @sources  = Source.all
  end

  def create
    @work = Work.new(work_params)

    if WorkSubmitter.new(@work).call
      redirect_to works_path
    else
      render :new
    end
  end

  private

  def work_params
    params.require(:work).permit(:operation_id, :source_id, parameters: [])
  end
end
