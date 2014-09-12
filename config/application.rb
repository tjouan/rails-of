require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'csv'
require 'fileutils'
require 'open3'
require 'pathname'
require 'tempfile'

require 'opti_tools/geo_score'
require 'opti_tools/firstnames'

module OptiFront
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_record.schema_format :sql

    config.force_ssl = true if ENV.key? 'OPTI_FRONT_FORCE_SSL'

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
    config.time_zone = 'Paris' unless Rails.env.test?

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :fr unless Rails.env.test?

    config.exceptions_app = self.routes

    config.action_dispatch.default_headers.clear

    config.action_view.field_error_proc = proc do |html_tag, instance|
      html_tag.html_safe
    end

    config.assets.precompile += %w[
      charts.js
      operations.js
      zopim.js
    ]

    config.action_mailer.delivery_method = :sendmail
    ActionMailer::Base.sendmail_settings = {
      arguments: '-i -f tj+datacube_opti_front@a13.fr'
    }


    config.host       = ENV.fetch('OPTI_FRONT_HOST', 'localhost.invalid').freeze
    config.host_prod  = 'beta.optidm.fr'

    config.sources_path = Rails.env.test? ?
      File.join('data', Rails.env, 'sources') :
      File.join('data', 'sources')
  end

  UnknownSourceError = Class.new(RuntimeError)
end
