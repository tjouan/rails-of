source 'https://rubygems.org'


gem 'rails',          '~> 4.1.1'
gem 'pg',             '~> 0.17'
gem 'tzinfo-data',    '~> 1.2014.2'
gem 'unicorn-rails',  '~> 2.1'

gem 'haml-rails',     '~> 0.5'

gem 'coffee-rails',   '~> 4.0'
gem 'sass-rails',     '~> 4.0'
gem 'uglifier',       '~> 2.0'

gem 'jquery-rails',   '~> 3.1'

gem 'backburner',     '~> 0.4'

gem 'geo_score',      git: 'git:datacube/geo_score'


group :development, :test do
  gem 'pry-rails'

  gem 'rspec',              '~> 2.14'
  gem 'rspec-rails',        '~> 2.14'

  gem 'factory_girl_rails', '~> 4.4'

  gem 'shoulda-matchers',   '~> 2.6'

  gem 'capybara',           '~> 2.3'

  gem 'guard-rspec',        '~> 4.2.9', require: false
  gem 'celluloid',          '0.16.0.pre', require: false

  gem 'spork',              '~> 1.0rc'
  gem 'spork-rails',        '~> 4.0'
  gem 'guard-spork',        '~> 1.5'
end

group :test do
  gem 'backburner_spec',    git: 'git://github.com/ogerman/backburner_spec'
end
