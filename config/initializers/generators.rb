Rails.application.config.generators do |g|
  g.helper      false
  g.javascripts false
  g.stylesheets false

  g.test_framework :rspec,
    controller_specs: false,
    request_specs: false,
    routing_specs: false,
    view_specs: false
end
