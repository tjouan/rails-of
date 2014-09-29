class WorksController < ApplicationController
  WORK_PARAMETERS = [:id, :target, :cost, :margin, { ignore: [] }].freeze
  ACTIVATION_REQUIRED_MESSAGE =
    'Vous devez activer votre compte pour utiliser les outils'.freeze

  before_filter :warn_when_not_activated, except: :index
  before_action :set_work, only: :show

  def index
    @works = current_user.works
  end

  def show
  end

  def new
    warn_when_not_activated

    @work     = WorkForm.build(params.slice :operation_id, new_work)
    @sources  = current_user.sources
  end

  def create
    warn_when_not_activated true and return

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

  def warn_when_not_activated(redirect = false)
    return if current_user.active?
    flash[redirect ? :error : :notice] = ACTIVATION_REQUIRED_MESSAGE
    flash.discard unless redirect
    redirect_to dashboard_path if redirect
    redirect
  end
end
