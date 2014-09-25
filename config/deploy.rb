require 'producer/rails'


set :repository,      'git:datacube/opti-front'
set :app_path,        'www/opti-front'
set :app_mkdir,       %w[data data/sources]

set :queue,           :backburner
set :queue_workers,   (target.include? 'prod') ? 2 : 1

set :www_server,      :unicorn
set :www_workers,     2
set :www_config_path, 'config/unicorn.rb'
set :www_pid_path,    'tmp/run/www.pid'
set :www_sock_path,   'tmp/run/www.sock'


deploy
