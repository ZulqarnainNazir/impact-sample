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

    @contact_present = false
    if params[:invite][:invitee][:email].present?
      if @business.contacts.where(email: params[:invite][:invitee][:email]).present?
        @contact_present = true
      end
    end

    #has an invite already been sent? if so, alert the user and redirect and return
    @invitee_contact = current_user.find_invite_by_invitee_id(params[:invite][:invitee][:email], @business, params[:invite][:invitee_id])
    if !@invitee_contact.nil?  
      flash[:notice] = "You already sent an invite to this email address.
      #{view_context.link_to('View this contact', edit_business_crm_contact_path(
        @business.id, @invitee_contact.id))} to see when 
      the next invite is scheduled to send."
      redirect_to new_business_crm_invite_path and return #and return is necessary to stop all other tasks within the action
    elsif current_user.invite_sent_email?(params[:invite][:invitee][:email]) == true
      if @contact_present == false
        @new_contact = Contact.new(invitee_params)
        @new_contact.business_id = params[:business_id]
        @new_contact.save
        flash[:notice] = "You already sent an invite to this email address. However, it does not look like 
        this email is in your contact list.
        We've taken care of that for you
        #{view_context.link_to('here', edit_business_crm_contact_path(
          @business.id, @new_contact.id))}."
      elsif @contact_present == true
        @contact = params[:invite][:invitee_id].present? ? Contact.find(params[:invite][:invitee_id]) : @business.contacts.where(email: params[:invite][:invitee][:email]).first
        flash[:notice] = "It looks like you already sent an invite to this email address. View the contact
        #{view_context.link_to('here', edit_business_crm_contact_path(
          @business.id, @contact.id))}."
      end        
      redirect_to new_business_crm_invite_path and return #and return is necessary to stop all other tasks within the action   
    end

    @invite = Invite.new(invite_params)
    @invite.inviter = current_user
    if !params[:invite][:type_of].present?
      @invite.type_of = 'basic'
    end

    if params[:invite][:invitee_id].blank? || @contact_present == false
      #invitee.update!(invitee_params)
      @invitee = Contact.new(invitee_params)
      @invitee.business_id = params[:business_id]
      @invite.invitee = @invitee
      @invitee.save!
    elsif Contact.find(params[:invite][:invitee_id]).present?
      @contact = Contact.find(params[:invite][:invitee_id]).present?
      @invite.invitee = @contact
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
    @invite.reload
    if !@invite.invitee.opted_out?
      if @invite.type_of == 'membership_1'
        if @invite.send_member_invite(@business) #method used here is found in invite model
          if @contact_present == true
            flash[:notice] = "Invite successfully sent! We didn't create a new contact for you, one
            already exists with the email address you provided."
          else
            flash[:notice] = "Invite successfully sent!"
          end
          redirect_to business_crm_companies_path and return
        else
          flash[:alert] = "Something went wrong. Please try again."
          render 'new'
        end
      elsif @invite.type_of == 'basic'
        if @invite.send_basic_invite(@business) #method used here is found in invite model
          if @contact_present == true
            flash[:notice] = "Invite successfully sent. We didn't create a new contact for you, one
            already exists with the email address you provided."
          else
            flash[:notice] = "Invite successfully sent."
          end
          redirect_to business_crm_companies_path and return
        else
          flash[:alert] = "Something went wrong. Please try again."
          render 'new'
        end
      elsif @invite.type_of == 'membership_2'
        if @invite.send_member_invite_2(@business) #method used here is found in invite model
          if @contact_present == true
            flash[:notice] = "Your invite was sent successfully! We didn't create a new contact for you, one
            already exists with the email address you provided."
          else
            flash[:notice] = "Your invite was sent successfully!"
          end
          redirect_to business_crm_companies_path and return
        else
          flash[:alert] = "Something went wrong. Please try again."
          render 'new'
        end
      else
        flash[:alert] = "Something went wrong. Please try again."
        render 'new'
      end
    else
      flash[:alert] = "Sorry, that contact has opted-out of receiving emails."
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
