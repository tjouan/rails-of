class Admin::ModelPresenter
  DEFAULT_OPTIONS = {
    list_attrs: {}
  }.freeze

  extend Forwardable
  def_delegators :@model, :model_name

  attr_reader :model

  def initialize(model, options = {})
    @model    = model
    @options  = DEFAULT_OPTIONS.merge options
  end

  def singular_name
    model.model_name.singular
  end

  def plural_name
    model.model_name.plural
  end

  def edit?
    has_route_for :edit
  end

  def new?
    has_route_for :new
  end

  def destroy?
    has_route_for :destroy
  end

  def list_attrs
    @options[:list_attrs]
  end


  private

  def has_route_for(action)
    routes_for_resource(model_name.route_key).any? do |e|
      e.defaults[:action] == action.to_s
    end
  end

  def routes_for_resource(resource_key)
    @_resource_routes ||= Rails.application.routes.routes.select do |e|
      e.defaults[:controller] == 'admin/%s' % resource_key
    end
  end
end
