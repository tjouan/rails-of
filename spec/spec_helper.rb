require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|
    # required for fixture_file_upload method
    config.include ActionDispatch::TestProcess
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    #config.order = 'random'
    config.after :all do
      `rm -f #{Rails.configuration.sources_path}/*`
    end
  end
end

Spork.each_run do
  # FIXME: it's not only the output, but even running test seems broken
  #if Spork.using_spork?
  #  RSpec.configure do |config|
  #    config.reset
  #    config.output_stream = $stdout
  #  end
  #end

  FactoryGirl.reload
end
