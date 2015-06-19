class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Permit additional parameters in Devise registration controllers.
  before_action if: :devise_controller? do
    devise_parameter_sanitizer.for(:sign_up) << %i[first_name last_name]
    devise_parameter_sanitizer.for(:account_update) << %i[first_name last_name]
  end

  protected

  # Customize redirect location for newly signed-up and signed-in users.
  def after_sign_in_path_for(user)
    if user.authorized_businesses.any?
      :businesses
    else
      :new_onboard_website_business
    end
  end

  # Sends a custom event to the Intercom service, if credentials are provided.
  def intercom_event(event_name, metadata = {})
    if ENV['INTERCOM_ID'].present? && ENV['INTERCOM_API_KEY'].present?
      Intercom::Client.new(
        app_id: ENV['INTERCOM_ID'],
        api_key: ENV['INTERCOM_API_KEY']
      ).events.create(
        event_name: event_name,
        email: current_user.email,
        created_at: metadata.delete(:created_at) || Time.zone.now.to_i,
        metadata: metadata,
      )
    end
  end

  # Makes a GET request with `payload` to the connect `path` and returns to
  # decoded response.
  def connect_to(path, payload = {})
    token = ConnectToken.encode(payload)
    uri = URI(ENV['CONNECT_URL'] + path)
    uri.query = URI.encode_www_form({ token: token })
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      ConnectToken.decode(response.body)
    else {}
    end
  end
end
