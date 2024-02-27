#REDIS_CLIENT = Redis.new(host: 'mmgg-payments-redis', port: 6379, db: 0)
REDIS_CLIENT = Redis.new(host: ENV['REDIS_HOST'], port: 6379, db: 0)