Backburner.configure do |config|
  log_destination = Rails.env.production? ? 'log/worker.log' : $stdout

  config.beanstalk_url  = 'beanstalk://127.0.0.1'
  config.tube_namespace = 'opti'
  config.logger         = Logger.new(log_destination)
  config.on_error       = lambda { |e| $stderr.puts e }
end
