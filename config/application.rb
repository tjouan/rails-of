require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

require 'pathname'
require 'tempfile'
require 'fileutils'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OptiFront
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # FIXME: we must find a better solution with either a helper, or assign TZ
    # only from user session/preferences.
    # http://www.elabs.se/blog/36-working-with-time-zones-in-ruby-on-rails
    # http://jessehouse.com/blog/2013/11/15/working-with-timezones-and-ruby-on-rails/
    # http://viget.com/extend/using-time-zones-with-rails
    # http://stackoverflow.com/questions/6060436/rails-3-how-to-get-todays-date-in-specific-timezone
    # http://stackoverflow.com/questions/5267170/how-to-display-the-time-in-users-timezone
    config.time_zone = 'Paris'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :fr

    config.exceptions_app = self.routes
  end
end
