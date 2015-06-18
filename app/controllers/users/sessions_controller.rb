class Users::SessionsController < Devise::SessionsController
  def create
    user = User.where(email: user_params[:email], cce_id: nil).first

    if user
      super
    else
      payload = connect_to('/session', email: user_params[:email], password: user_params[:password])

      if payload
        user = User.where(email: user_params[:email]).first_or_initialize

        if user.new_record?
          user.assign_attributes(
            cce_id: payload[:id],
            cce_url: payload[:site_url],
            first_name: payload[:first_name],
            last_name: payload[:last_name],
          )
          user.skip_confirmation!
          user.save(validate: false)
        elsif !user.cce_id?
          user.update_attributes cce_id: payload[:id]
        end

        self.resource = user
        set_flash_message(:notice, :signed_in) if is_flashing_format?
        sign_in(resource_name, resource)
        respond_with resource, location: after_sign_in_path_for(resource)
      else
        self.resource = resource_class.new(sign_in_params)
        flash.now.alert = 'Invalid email or password.'
        render :new
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :remember_me,
    )
  end
end
