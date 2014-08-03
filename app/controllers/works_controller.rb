class WorksController < ApplicationController
  WORK_PARAMETERS = [:id, :target, { ignore: [] }].freeze

  before_action :set_work, only: :show

  def index
    @works = current_user.works
  end

  def show
  end

  def new
    @work     = WorkForm.build(params.slice :operation_id, new_work)
    @sources  = current_user.sources
  end

  def create
    @work = WorkForm.build(work_params, new_work)

    if WorkSubmitter.new(@work).call
      redirect_to dashboard_path
    else
      render :new
    end
  end


  private

  def new_work
    current_user.works.new
  end

  def set_work
    @work = current_user.works.find params[:id]
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
