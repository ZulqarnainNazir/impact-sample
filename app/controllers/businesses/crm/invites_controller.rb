class Businesses::Crm::InvitesController < Businesses::BaseController
  before_action :new do
    # if following a link already associated with a specific company or contact, the information
    # should be fetched and pre-filled into the form for the user.
    @invite = Invite.new(initial_invite_params)
    # @invite.invite_as_member = true if @business.membership_org
    @business.membership_org ? @invite.type_of = 'membership_1' : @invite.type_of = 'basic'

  end

  def index
  end

  def new
  end

  def create
    params[:invite][:type_of] ||= 'basic'
    @invite = Invite.new(invite_params)
    @invite.inviter = current_user

    unless !params[:invite][:invitee_id].blank? && Contact.find(params[:invite][:invitee_id]).present?
      #invitee.update!(invitee_params)
      @invitee = Contact.new(invitee_params)
      @invitee.business_id = params[:business_id]
      @invite.invitee = @invitee
      # @invitee.save!
    end
    # unless @invite.skip_company || (!params[:invite][:company_id].blank? && Company.find(params[:invite][:company_id]).present?)
    #   # raise StandardError, params
    #   @company = Company.create(name: params[:invite][:company][:name], user_business_id: params[:business_id])
    #   @invite.company_id = @company.id
    #   # raise StandardError, @invite.to_json
    #   # @invite.save!
    # end

    # raise StandardError, @invite.to_json
    # if @invite.skip_company || params[:invite][:company_id].blank? || !Company.find(params[:invite][:company_id]).present?
    #   @invite.type_of == nil
    #   if InvitesMailer.quick_invite(@invite, @business).deliver_now
    #     flash[:notice] = "Invite successfully sent."
    #     redirect_to business_crm_companies_path and return
    #   else
    #     flash[:alert] = "Something went wrong. Please try again."
    #     render 'new'
    #   end
    # end
    if @invite.skip_company || params[:invite][:company_id].blank? || !Company.find(params[:invite][:company_id]).present?
      @invite.skip_company = true
      @invite.company_id = nil
    end
    @invite.save!
    if @invite.type_of == 'membership_1'
      if @invite.send_member_invite(@business) #method used here is found in invite model
        flash[:notice] = "Invite successfully sent."
        redirect_to business_crm_companies_path
      else
        flash[:alert] = "Something went wrong. Please try again."
        render 'new'
      end

    elsif @invite.type_of == 'basic'
      if @invite.send_basic_invite(@business) #method used here is found in invite model
        flash[:notice] = "Invite successfully sent."
        redirect_to business_crm_companies_path
      else
        flash[:alert] = "Something went wrong. Please try again."
        render 'new'
      end

    elsif @invite.type_of == 'membership_2'
      if @invite.send_member_invite_2(@business) #method used here is found in invite model
        flash[:notice] = "Invite successfully sent."
        redirect_to business_crm_companies_path
      else
        flash[:alert] = "Something went wrong. Please try again."
        render 'new'
      end
    else
      flash[:alert] = "Something went wrong. Please try again."
      render 'new'
    end
  end

  private

  def mailer_args
    [
      @business.id, #sender
      params[:invite][:invitee][:email], #recipient
      @invite.company_id, #business_id of recipient
      @invite.invitee_id,
      @invite.invite_as_member,
      @invite.inviter,
      @invite.message,
    ]
  end

  def default_url_options(options = nil)
    if Rails.env.production?
      { :host => ENV['HOST'] }
    else
      { :host => "impact.locabledev.com" }
    end
  end

  def initial_invite_params
    params.permit(:company_id, :invitee_id)
  end

  def invite_params
    params.require(:invite).permit(
      :message,
      :company_id,
      :invitee_id,
      :type_of,
      :skip_company,
      :company_attributes => [
        :name,
      ],
      :invitee_attributes => [
        :first_name,
        :last_name,
        :email,
      ],
    )
  end

  def invitee_params
    params.require(:invite).require(:invitee).permit(
      :first_name,
      :last_name,
      :email,
    )
  end
end
