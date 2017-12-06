class Businesses::AccountModulesController < Businesses::BaseController
  before_action :integerize_params, :only => [:create]
  before_action :load_module, :except => [:index, :create]

  def index

  end

  def create
    intercom_message = ""
    appcues_message = ""

    if params[:active] == "true"
      if @business.module_present?(params[:kind])
        @module = @business.account_modules.where(kind: params[:kind]).first
        @module.active = true

        appcues_message = appcues_create_message("reactivated", params[:kind])
        intercom_message = intercom_create_message("reactivated", params[:kind])
      else
        @module = AccountModule.new(new_account_module_params)
        @module.business = @business

        appcues_message = appcues_create_message("activated", params[:kind])
        intercom_message = intercom_create_message("activated", params[:kind])
      end
    elsif params[:active] == "false"
      @module = @business.account_modules.where(kind: params[:kind]).first
      @module.active = false

      appcues_message = appcues_create_message("deactivated", params[:kind])
      intercom_message = intercom_create_message("deactivated", params[:kind])
    end
    if @module.save
      flash[:appcues_event] = appcues_message
      intercom_event intercom_message
    end

    redirect_to business_account_modules_path

    # respond_to do |format|
    #   format.html
    #   format.json
    # end
  end

  def edit

  end

  def update
    @content = params[:content]

    if params[:enable]
      AccountModule.update(params[:id].to_i, params[:content].to_sym => true)
    else
      AccountModule.update(params[:id].to_i, params[:content].to_sym => false)
    end
    # respond_to do |format|
    #   format.js {render layout: false}
    # end
  end

  def delete

  end

  private

  def appcues_create_message(event, kind_number)
    kind_number = kind_number.to_i
    message = ""
    if kind_number == 0
      message = "marketing_missions"
    elsif kind_number == 1
      message = "content_engine"
    elsif kind_number == 2
      message = "local_connections"
    elsif kind_number == 3
      message = "customer_reviews"
    elsif kind_number == 4
      message = "form_builder"
    elsif kind_number == 5
      message = "website"
    end
    # marketing_missions: 0,
    # content_engine: 1,
    # local_connections: 2,
    # customer_reviews: 3,
    # form_builder: 4,
    # website: 5
    "Appcues.track('module #{event}: #{message} ')"
  end

  def intercom_create_message(event, kind_number)
    #activated
    #deactivated
    #reactivated
    kind_number = kind_number.to_i
    message = "" 
    if kind_number == 0
      message = "marketing-missions"
    elsif kind_number == 1
      message = "content-engine"
    elsif kind_number == 2
      message = "local-connections"
    elsif kind_number == 3
      message = "customer-reviews"
    elsif kind_number == 4
      message = "form-builder"
    elsif kind_number == 5
      message = "website"
    end

    "#{message}-#{event}"
  end

  def load_module
    @module = AccountModule.find(params[:id])
  end

  def new_account_module_params
    params.permit(
      :kind,
      :active,
      :post,
      :before_after,
      :event,
      :offer,
      :job,
      :gallery,
      :quick_post
      )
  end

  def integerize_params
    if params[:kind].present?
      params[:kind] = params[:kind].to_i
    end
  end
end