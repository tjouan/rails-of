Backburner.configure do |config|
  config.beanstalk_url = 'beanstalk://127.0.0.1'
  config.tube_namespace = 'opti'
  config.on_error = lambda { |e| $stderr.puts e }
end
