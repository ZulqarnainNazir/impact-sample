class Connect::SessionsController < ApplicationController
  def create
    payload = ConnectToken.decode(params[:token])
    user = current_user || User.find_by_cce_id(payload[:id])

    unless user
      user = User.where(email: payload[:email]).first_or_initialize

      if user.new_record?
        user.assign_attributes(
          cce_id: payload[:id],
          cce_url: payload[:site_url],
          first_name: payload[:first_name],
          last_name: payload[:last_name],
        )
        user.skip_confirmation!
        user.save(validate: false)
      else
        user.update_attributes(
          cce_id: payload[:id],
          cce_url: payload[:site_url],
        )
      end
    end

    if payload[:business_url].present?
      sign_in(user)
      redirect_to [:new_onboard_website_business, cce_business_url: payload[:business_url]]
    else
      sign_in_and_redirect(user)
    end
  end
end
