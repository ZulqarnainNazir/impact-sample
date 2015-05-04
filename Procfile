web: bundle exec passenger start -p $PORT --max-pool-size 3
worker: bundle exec sidekiq -q image,3 -q mailers,2 -q default
