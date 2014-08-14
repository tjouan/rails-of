class OperationsController < ApplicationController
  before_action :set_operation, only: :show

  def index
    @operations = Operation.all
  end

  def show
  end


  private

  def set_operation
    @operation = Operation.find(params[:id])
  end
end
