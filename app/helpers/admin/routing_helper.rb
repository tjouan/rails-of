module Admin::RoutingHelper
  def collection_path(model)
    send("admin_#{model.model_name.route_key}_path")
  end

  def object_path(object)
    send("admin_#{object.class.model_name.singular_route_key}_path", object)
  end

  def new_path(model)
    send("new_admin_#{model.model_name.singular_route_key}_path")
  end

  def edit_path(object)
    send("edit_admin_#{object.class.model_name.singular_route_key}_path", object)
  end
end
