www:        rails s -b ::1 -p $PORT
queue:      beanstalkd -l 127.0.0.1
worker:     bundle exec rake backburner:work