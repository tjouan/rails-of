class Admin::ResourcesController < Admin::BaseController
  include Admin::RoutingHelper

  OBJECT_FORM_FIELDS = {
    Article => {
      zone: :text_field,
      body: :text_area
    },
    Offer => {
      name:     :text_field,
      ref:      :text_field,
      price:    :number_field,
      visible:  :check_box
    },
    Operation => {
      name:         :text_field,
      ref:          :text_field,
      description:  :text_area,
      help_intent:  :text_area,
      help_usage:   :text_area
    },
    Subscription => {
      quota:        :number_field
    },
    User => {
      name:                   :text_field,
      email:                  :email_field,
      password:               :password_field,
      password_confirmation:  :password_field,
      active:                 :check_box,
      admin:                  :check_box
    }
  }

  OBJECT_LIST_ATTRS = {
    Work => {
      user: proc { |e| e.user.email }
    }
  }

  before_filter :set_model
  before_filter :set_resource,    only: %i[index show new edit]
  before_action :set_collection,  only: :index
  before_action :set_object,      only: %i[show edit update destroy]
  before_action :set_fields,      only: %i[new edit create update]

  def index
  end

  def show
  end

  def new
    @object = @model.new
  end

  def edit
  end

  def create
    @object = @model.new object_params

    if @object.save
      redirect_to collection_path(@model),
        notice: "#{model_name.singular.capitalize} was successfully created."
    else
      set_resource
      render :new
    end
  end

  def update
    if @object.update object_params
      redirect_to collection_path(@model),
        notice: "#{model_name.singular.capitalize} was successfully updated."
    else
      set_resource
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

  def set_resource
    @resource = Admin::ModelPresenter.new(
      @model,
      list_attrs: (OBJECT_LIST_ATTRS[@model] or {})
    )
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
