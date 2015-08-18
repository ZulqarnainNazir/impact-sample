workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.establish_connection

  if ENV['REDISTOGO_URL'].present? && Rails.env.production?
    Sidekiq.configure_client do |config|
      config.redis = {
        size: 16,
        timeout: 1,
        url: ENV['REDISTOGO_URL'],
      }
    end
  end
end
