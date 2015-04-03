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
    user.businesses.any? ? :businesses : :new_onboard_website_business
  end

  def block_attributes
    [
      :id,
      :theme,
      :style,
      :heading,
      :subheading,
      :text,
      :image_placement_id,
      :image_placement_destroy,
      :image_id,
      :image_cache_url,
      :image_alt,
      :image_title,
      :image_file_name,
      :image_file_size,
      :image_content_type,
      :link_id,
      :link_type,
      :link_version,
      :link_label,
      :link_external_url,
      :link_no_follow,
      :link_target_blank,
      :background_color,
      :foreground_color,
      :_destroy,
    ]
  end
end
