Rails.application.configure do
  config.action_controller.asset_host = Rails.application.secrets.aws_cloudfront_host
  config.action_controller.perform_caching = true
  config.action_mailer.default_url_options = { host: "www.#{Rails.application.secrets.host}" }
  config.active_record.dump_schema_after_migration = false
  config.active_support.deprecation = :notify
  config.assets.compile = false
  config.assets.css_compressor = :sass
  config.assets.digest = true
  config.assets.js_compressor = :uglifier
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.eager_load = true
  config.i18n.fallbacks = true
  config.log_level = :debug
  config.log_tags = [:uuid]
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.time_zone = 'UTC'

  config.autoload_paths += Dir["#{config.root}/app/classes/**/"]

  config.action_mailer.smtp_settings = {
    address: Rails.application.secrets.aws_ses_smtp_address,
    port: Rails.application.secrets.aws_ses_smtp_port,
    user_name: Rails.application.secrets.aws_ses_smtp_username,
    password: Rails.application.secrets.aws_ses_smtp_password,
    authentication: :login,
  }

  # Memcached
  if [ENV['MEMCACHEDCLOUD_SERVERS'], ENV['MEMCACHEDCLOUD_USERNAME'], ENV['MEMCACHEDCLOUD_PASSWORD']].all?(&:present?)
    config.cache_store = :dalli_store, ENV['MEMCACHEDCLOUD_SERVERS'].split(','), {
      username: ENV['MEMCACHEDCLOUD_USERNAME'],
      password: ENV['MEMCACHEDCLOUD_PASSWORD'],
    }
  end

  # Paperclip
  config.paperclip_defaults[:url] = ':s3_alias_url'
  config.paperclip_defaults[:s3_host_alias] = Rails.application.secrets.aws_cloudfront_host
end
