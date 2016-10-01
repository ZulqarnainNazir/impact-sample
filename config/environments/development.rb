Rails.application.configure do
  config.action_controller.perform_caching = false
  config.action_mailer.default_url_options = { host: Rails.application.secrets.host }
  config.action_mailer.raise_delivery_errors = false
  config.action_view.raise_on_missing_translations = true
  config.active_record.migration_error = :page_load
  config.active_support.deprecation = :log
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.eager_load = false

  # Paperclip

  config.paperclip_defaults = {
    storage: :s3,
    path: ':class/:id/:attachment-:style-:attachment_timestamp-:filename',
    s3_permissions: :public_read,
    s3_credentials: {
      bucket: Rails.application.secrets.aws_s3_bucket,
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    }
  }
  # config.paperclip_defaults[:url] = ':s3_domain_url'
end
