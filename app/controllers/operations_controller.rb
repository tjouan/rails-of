class OperationsController < ApplicationController
  def index
    @operations = Operation.all
  end

  def show
    @operation = Operation.find(params[:id])
  end
end
