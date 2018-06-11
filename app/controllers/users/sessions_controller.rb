class Users::SessionsController < Devise::SessionsController
  before_action :set_affiliate_cookie, :only => [:new]
  # layout 'landing'

  respond_to :json

  def new
    super
  end

  def create
    user = User.where(email: user_params[:email]).first

    if user && user.encrypted_password?
      # if the issue is the honey pot we don't want to let the user/bot know that it failed.
      if !user_params[:honey].blank?
        flash.now.alert = 'Successfully Logged In'
        render :new
      else
        super
      end
    else
      locable_user = LocableUser.find_by_email(user_params[:email]) rescue nil

      if locable_user && locable_user.authenticate(user_params[:password])
        user = User.where(email: user_params[:email]).first_or_initialize

        if user.new_record?
          user.assign_attributes(
            cce_id: locable_user.id,
            first_name: locable_user.first_name,
            last_name: locable_user.last_name,
          )
          user.skip_confirmation!
          user.save(validate: false)
        elsif !user.cce_id?
          user.update_attributes(
            cce_id: locable_user.id,
          )
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

  def set_affiliate_cookie
    @affiliate_token = SubscriptionAffiliate.find_by(token: params[:r]).token rescue nil
    unless @affiliate_token.nil?
      cookies[:affiliate_token] = { value: @affiliate_token, expires: 1.month.from_now }
    end
  end

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :remember_me,
      :honey,
    )
  end
end
