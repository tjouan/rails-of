class Admin::ModelPresenter
  extend Forwardable
  def_delegators :@model, :model_name

  attr_reader :model

  def initialize(model)
    @model = model
  end

  def singular_name
    model.model_name.singular
  end

  def plural_name
    model.model_name.plural
  end
end
