www:        rails s -b ::1 -p ${PORT:="3000"}
queue:      sh -c 'beanstalkd -l 127.0.0.1 -p $BEANSTALK_PORT'
worker:     bundle exec rake backburner:work
redis:      sh -c 'redis-server --port $REDIS_PORT --dir db'
