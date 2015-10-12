class ApplicationJob < ActiveJob::Base
  queue_as :default

  rescue_from ActiveJob::DeserializationError, with: -> {}

  def notify_locable(path, payload = {})
    token = ConnectToken.encode(payload)
    uri = URI(ENV['CONNECT_URL'] + path)
    uri.query = URI.encode_www_form({ token: token })
    Net::HTTP.get_response(uri)
  end

  def website_host(website)
    if website.webhost.try(:primary?)
      website.webhost.name
    else
      [website.subdomain, Rails.application.secrets.host].join('.')
    end
  end
end
