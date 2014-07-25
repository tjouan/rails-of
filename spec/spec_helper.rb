require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  ActiveRecord::Migration.maintain_test_schema!

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.after :all do
      `rm -f #{Rails.configuration.sources_path}/*`
    end
  end
end

Spork.each_run do
  FactoryGirl.reload
end
