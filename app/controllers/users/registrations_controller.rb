class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_affiliate_cookie, :only => [:new]
  before_action only: %i[update] do
    %i[app_marketing_reminders email_marketing_reminders].each do |attribute|
      devise_parameter_sanitizer.for(:account_update) << attribute
    end
  end

  respond_to :json

  def new
    query = params[:query].to_s.strip
    if query.present?
      @businesses = Business.where("name ILIKE ?", "%#{query}%").limit(6)
    else
      @businesses = Business.all.limit(6)
    end
    @categories = Category.alphabetical
    if params[:contact_id]
      @invited_user = Contact.find(params[:contact_id])
    end
    if params[:company_id]
      @invited_company = Company.find(params[:company_id]) #.try(:business)
      # raise StandardError, @invited_business.to_json
    end
    @quick_invite = params[:quick_invite]
    @build_plan_id = SubscriptionPlan.find_by(name: "Build").id
  	super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    if params[:confirm].present? && params[:confirm] == 'false'
      resource.skip_confirmation!
    end
    # if the issue is the honey pot we don't want to let the user/bot know that it failed.
    if !sign_up_params[:honey].blank?
      redirect_to "/users/sign_up", :flash => { :notice => :signed_up }
      return
    end
    # Skip confirmation email for now, as rendering depends on the business being created
    resource.skip_confirmation_notification!
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end

      if resource.opted_out?
        #this conditional is leveraging the functionality of the gem 'mailkick'
        #it checks to see if the new user had previously opted-out (unsubscribed) from
        #emails from IMPACT. if so, it "opts them in" (subscribes them back) to emails
        #from IMPACT. It does so regardless of whether it was a Contact (from Contact table)
        #that opted out or a User. The mailkick table is polymorphic, and the methods at play
        #simply find the email address that opted-out, and opts it in, regardless of whether that
        #email belongs to a User, Contact, or some other table.
        resource.opt_in
      end

      respond_with resource
      # clean_up_passwords resource
      # set_minimum_password_length
      # respond_with resource
    end
  end

  private

  def set_affiliate_cookie
    @affiliate_token = SubscriptionAffiliate.find_by(token: params[:r]).token rescue nil
    unless @affiliate_token.nil?
      cookies[:affiliate_token] = { value: @affiliate_token, expires: 1.month.from_now }
    end
  end

  def sign_up_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :honey,
    )
  end

end
