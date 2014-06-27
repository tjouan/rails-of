repository      = 'git:datacube/opti-front'
app_path        = 'www/opti-front'
www_workers     = 2

www_config_path = "#{app_path}/config/unicorn.rb"
www_pid_path    = 'tmp/run/www.pid'
www_sock_path   = 'tmp/run/www.sock'

source 'vendor/deploy/stdlib/fs'
source 'vendor/deploy/stdlib/git'

macro :bundle_install do
  gemfile = "--gemfile #{app_path}/Gemfile"

  condition { no_sh "bundle check #{gemfile}" }

  sh "bundle install --without development test #{gemfile}"
end


=begin
ensure_dir app_path, 0701

#git_clone repository, app_path
task :app_dir_init do
  condition { no_git? app_path }

  sh "git clone --depth 1 #{repository} #{app_path}"

  %w[tmp tmp/run data data/sources].each do |e|
    mkdir File.join(app_path, e), 0700
  end
end

task :db_config do
  path = "#{app_path}/config/database.yml"
  conf = <<-eoh
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5

production:
  <<: *default
  database: optidm-qa1
  eoh

  condition { no_file? path }

  file_write path, conf
end

task :db_init do
  condition { no_sh 'psql -l | grep -E "^ +optidm-qa1"' }

  sh "cd #{app_path} && bundle exec rake db:create"
end

task :www_config do
  conf = <<-eoh
worker_processes  #{www_workers}
preload_app       false
pid               '#{www_pid_path}'
listen            "\#{ENV['HOME']}/#{app_path}/#{www_sock_path}"
  eoh

  condition { no_file_contains www_config_path, conf }

  file_write www_config_path, conf
end

bundle_install

task :www_start do
  condition { no_file? [app_path, www_pid_path].join('/') }

  sh "cd #{app_path} && bundle exec unicorn -c config/unicorn.rb -D"
end
=end


git_update app_path

bundle_install

task :db_migrate do
  condition { sh "cd #{app_path} && bundle exec rake db:migrate:status | grep -E '^ +down'" }

  sh "cd #{app_path} && bundle exec rake db:migrate"
end

task :assets_update do
  sh "cd #{app_path} && bundle exec rake assets:precompile"
  sh "cd #{app_path} && chmod 644 public/assets/*"
end

task :www_reload do
  sh "kill -HUP $(cat #{app_path}/#{www_pid_path})"
end


# tmux new -d -s app "echo hello; sleep 4; zsh"
#
# task :www_stop do
#   sh "kill -QUIT $(cat #{app_path}/#{www_pid_path})"
# end
