class Connect::SessionsController < ApplicationController
  def create
    payload = ConnectToken.decode(params[:token])
    user = current_user
    user = User.find_by_cce_id(payload[:id]) if payload[:id].present?
    user_is_new = false

    if !user && payload[:id].present?
      user = User.where(email: payload[:email]).first_or_initialize

      if user.new_record?
        user_is_new = true
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

    if user
      sign_in(user)

      if user_is_new
        flash.notice = 'Welcome to the IMPACT marketing suite!'
      else
        flash.notice = 'Welcome back to the IMPACT marketing suite!'
      end

      if payload[:business_url].present?
        redirect_to [:new_onboard_website_business, cce_business_url: payload[:business_url]]
      else
        redirect_to after_sign_in_path_for(user)
      end
    else
      redirect_to new_user_session_path, alert: 'We were unable to automatically sign you in.'
    end
  end
end
