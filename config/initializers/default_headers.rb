# Remove non-standards default headers:
#   * X-Frame-Options
#   * X-Xss-Protection
#   * X-Content-Type-Options
Rails.application.config.action_dispatch.default_headers.clear
