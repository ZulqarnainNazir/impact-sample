class Businesses::Crm::InvitesController < Businesses::BaseController
  before_action :new do
    # if following a link already associated with a specific company or contact, the information
    # should be fetched and pre-filled into the form for the user.
    @invite = Invite.new(initial_invite_params)
  end

  def index
  end

  def new
  end

  def create
    # unless params[:invite][:invitee_id]
    #   @invite = Invite.new(invite_params)
    #   @invite.invitee
    #   @invite.inviter = current_user
    # else
    @invite = Invite.new(invite_params)
    @invite.inviter = current_user
    if params[:invitee_id]
      invitee = find_by_id(params[:invitee_id])
      invitee.update!(invitee_params)
    else
      invitee = Contact.new(invitee_params)
      invitee.business_id = params[:business_id]
      @invite.invitee = invitee
    end
    @invite.save!
    redirect_to :root

    InvitesMailer.basic_invite(
      params[:invite][:invitee][:email], #recipient
      @invite.company_id, #business_id of recipient
      @invite.invitee_id
    ).deliver_later(wait: 5.seconds)

    # once created the invite should actually send a message to the email of the invitee.
    # IMPORTANT: the custom invite link included in the email should be
    # /onboard/users/new/?company_id=#{invite.company_id}&contact_id=#{invite.invitee_id}
    # for the onboarding wizard to recognize and prefill the relevant parts.
  end

  private

  def initial_invite_params
    params.permit(:company_id, :invitee_id)
  end

  def invite_params
    params.require(:invite).permit(
      :company_id,
      :invitee_id,
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
