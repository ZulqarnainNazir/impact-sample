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
      @invitee.save!
    end
    @invite.save!
    if @invite.type_of == 'membership_1'
      if InvitesMailer.member_invite(*mailer_args).deliver_now
        flash[:notice] = "Invite successfully sent."
        redirect_to business_crm_companies_path
      else
        flash[:alert] = "Something went wrong. Please try again."
        render 'new'
      end

    elsif @invite.type_of == 'basic'
      if InvitesMailer.basic_invite(*mailer_args).deliver_now
        flash[:notice] = "Invite successfully sent."
        redirect_to business_crm_companies_path
      else
        flash[:alert] = "Something went wrong. Please try again."
        render 'new'
      end

    elsif @invite.type_of == 'membership_2'
      if InvitesMailer.member_invite(*mailer_args).deliver_now
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
