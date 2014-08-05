require 'securerandom'

repository      = 'git:datacube/opti-front'
app_path        = 'www/opti-front'
www_workers     = 2
queue_workers   = (env.target.include? 'prod') ? 2 : 1

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


if ENV.key? 'DEPLOY_INIT'
  ensure_dir app_path, 0701

  #git_clone repository, app_path
  task :app_dir_init do
    condition { no_git? app_path }

    sh "git clone --depth 1 #{repository} #{app_path}"

    %w[data data/sources tmp tmp/run].each do |e|
      mkdir File.join(app_path, e), 0700
    end
    sh "cd #{app_path} && chmod 701 tmp tmp/run"
  end

  bundle_install

  task :db_config do
    path = "#{app_path}/config/database.yml"
    conf = <<-eoh
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5

production:
  <<: *default
  database: #{env.target}
    eoh

    condition { no_file? path }

    file_write path, conf
  end

  task :db_check do
    condition { no_sh 'ON_ERROR_STOP=1 psql -l' }

    echo 'FATAL: Database is not accessible'
    sh 'false'
  end

  task :db_init do
    condition { no_sh 'psql -l | grep -E "^ +%s"' % env.target }

    sh "cd #{app_path} && bundle exec rake db:create db:migrate"
  end

  task :secrets_config do
    path = "#{app_path}/config/secrets.yml"
    conf = <<-eoh
production:
  secret_key_base: #{SecureRandom.hex(64)}
    eoh

    condition { no_file? path }

    file_write path, conf
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
else
  git_update app_path
end

bundle_install

task :db_migrate do
  condition { sh "cd #{app_path} && bundle exec rake db:migrate:status | grep -E '^ +down'" }

  sh "cd #{app_path} && bundle exec rake db:migrate"
end

task :assets_update do
  sh "cd #{app_path} && bundle exec rake assets:precompile"
  sh "cd #{app_path} && chmod 711 public public/assets"
  sh "cd #{app_path} && find public/assets -type d -exec chmod 711 {} \\;"
  sh "cd #{app_path} && find public/assets -type f -exec chmod 644 {} \\;"
end



if ENV.key? 'DEPLOY_INIT'
  task :www_start do
    condition { no_file? [app_path, www_pid_path].join('/') }

    sh "cd #{app_path} && bundle exec unicorn -c config/unicorn.rb -D"
  end

  task :app_start do
    condition { no_sh 'tmux has-session -t app' }

    sh "cd #{app_path} && tmux new -d -s app 'foreman start -c queue=1,worker=#{queue_workers}; zsh'"
  end

else
  task :app_stop do
    sh 'tmux kill-session -t app'
  end

  task :www_reload do
    sh "kill -HUP $(cat #{app_path}/#{www_pid_path})"
  end

  task :app_start do
    sh "cd #{app_path} && tmux new -d -s app 'foreman start -c queue=1,worker=#{queue_workers}; zsh'"
  end
end


# task :www_stop do
#   sh "kill -QUIT $(cat #{app_path}/#{www_pid_path})"
# end
