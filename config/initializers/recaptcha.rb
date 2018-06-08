Recaptcha.configure do |config|
  config.site_key  = ENV['RECAPTCHA_API_KEY']
  config.secret_key = ENV['RECAPTCHA_API_SECRET']
end
