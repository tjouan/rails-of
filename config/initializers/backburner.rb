Backburner.configure do |config|
  log_destination = Rails.env.production? ? 'log/worker.log' : $stdout

  config.beanstalk_url    = 'beanstalk://127.0.0.1:%s' % ENV['BEANSTALK_PORT']
  config.tube_namespace   = 'opti'
  config.logger           = Logger.new(log_destination)
  config.respond_timeout  = 3600 / 3
end
