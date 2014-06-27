www:        rails s -b ::1 -p $PORT
queue:      sh -c 'beanstalkd -l 127.0.0.1 -p $BEANSTALK_PORT'
worker:     bundle exec rake backburner:work
