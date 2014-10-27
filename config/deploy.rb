require 'producer/rails'


set :repository,      'git:datacube/opti-front'
set :app_path,        'www/opti-front'
set :app_mkdir,       %w[data/sources db]

set :db_seed,         true

# FIXME: should be a hash { redis: 1 }
set :processes,       "queue=1,redis=1,worker=#{target.include?('prod') ? 2 : 1}"

set :www_server,      :unicorn
set :www_workers,     2
set :www_timeout,     180
set :www_config_path, 'config/unicorn.rb'
set :www_pid_path,    'tmp/run/www.pid'
set :www_sock_path,   'tmp/run/www.sock'


deploy
