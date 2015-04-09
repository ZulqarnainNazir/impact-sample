require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(*Rails.groups)

module Impact
  class Application < Rails::Application
    config.action_dispatch.cookies_serializer = :json
    config.active_job.queue_adapter = :sidekiq
    config.active_record.raise_in_transactional_callbacks = true
    config.active_record.timestamped_migrations = false
    config.assets.version = '1.0'
    config.filter_parameters += %i[password password_confirmation]
    config.generators { |g| g.assets false }
    config.generators { |g| g.helper false }
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.yml')]
    config.session_store :cookie_store, key: '_impact_session'
    config.time_zone = 'Pacific Time (US & Canada)'

    # Paperclip
    config.paperclip_defaults = {
      storage: :s3,
      path: ':class/:id/:attachment-:style-:attachment_timestamp-:filename',
      s3_permissions: :public_read,
      s3_credentials: {
        bucket: Rails.application.secrets.aws_s3_bucket,
      }
    }

    # React
    config.react.addons = true
  end
end
