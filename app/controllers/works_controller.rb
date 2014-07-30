class WorksController < ApplicationController
  WORK_PARAMETERS = [:id, :target, { ignore: [] }].freeze

  before_action :set_work, only: :show

  def index
    @works = Work.all
  end

  def show
  end

  def new
    @work     = WorkForm.build(operation_id: params[:operation_id])
    @sources  = Source.all
  end

  def create
    @work = WorkForm.build(work_params)

    if WorkSubmitter.new(@work).call
      redirect_to dashboard_path
    else
      render :new
    end
  end


  private

  def set_work
    @work = Work.find(params[:id])
  end

  def work_params
    params.require(:work).permit(
      :operation_id, :source_id, :target_source_id, {
        parameters:
          params[:work][:parameters].is_a?(Hash) ? WORK_PARAMETERS : []
      }
    )
  end
end
