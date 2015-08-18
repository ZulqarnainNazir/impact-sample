web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q image,3 -q mailers,2 -q default
