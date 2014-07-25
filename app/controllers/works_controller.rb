class WorksController < ApplicationController
  WORK_PARAMETERS = [:id, :target, { ignore: [] }].freeze

  def index
    @works      = Work.all
    @operations = Operation.all
  end

  def new
    @work     = WorkForm.build(operation_id: params[:operation_id])
    @sources  = Source.all
  end

  def create
    @work = WorkForm.build(work_params)

    if WorkSubmitter.new(@work).call
      redirect_to works_path
    else
      render :new
    end
  end


  private

  def work_params
    params.require(:work).permit(
      :operation_id, :source_id, :target_source_id, {
        parameters:
          params[:work][:parameters].is_a?(Hash) ? WORK_PARAMETERS : []
      }
    )
  end
end
