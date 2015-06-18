class Connect::SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    if current_user
      redirect_to after_sign_in_path_for(current_user)
    else
      payload = ConnectToken.decode(params[:token])
      user = User.find_by_cce_id(payload[:id])

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

      sign_in_and_redirect(user)
    end
  end
end
