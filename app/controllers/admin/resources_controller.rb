class Admin::ResourcesController < Admin::BaseController
  include Admin::RoutingHelper

  OBJECT_FORM_FIELDS = {
    Operation => {
      name:         :text_field,
      ref:          :text_field,
      description:  :text_area
    },
    User => {
      name:                   :text_field,
      email:                  :email_field,
      password:               :password_field,
      password_confirmation:  :password_field,
      admin:                  :check_box
    }
  }

  before_filter :set_model
  before_action :set_collection,  only: :index
  before_action :set_object,      only: %i[show edit update destroy]
  before_action :set_fields,      only: %i[new edit create update]

  def index
    @model = Admin::ModelPresenter.new(@model)
  end

  def show
    @model= Admin::ModelPresenter.new(@model)
  end

  def new
    @object = @model.new
    @model  = Admin::ModelPresenter.new(@model)
  end

  def edit
    @fields = OBJECT_FORM_FIELDS[@model]
    @model  = Admin::ModelPresenter.new(@model)
  end

  def create
    @object = @model.new object_params

    if @object.save
      redirect_to collection_path(@model),
        notice: "#{model_name.singular.capitalize} was successfully created."
    else
      render :new
    end
  end

  def update
    if @object.update object_params
      redirect_to collection_path(@model),
        notice: "#{model_name.singular.capitalize} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @object.destroy
    redirect_to collection_path(@model),
      notice: "#{model_name.singular.capitalize} was successfully destroyed."
  end


  private

  def set_model
    @model = controller_name.classify.constantize
  end

  def set_collection
    @collection = @model.unscoped.order('created_at ASC')
  end

  def set_object
    @object = @model.find params[:id]
  end

  def set_fields
    @fields = object_fields
  end

  def object_params
    params.require(model_name.param_key.to_sym).permit(*object_fields)
  end

  def object_fields
    OBJECT_FORM_FIELDS[@model]
  end

  def model_name
    @model.model_name
  end
end
