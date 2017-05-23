class InvitesMailer < ApplicationMailer
  def basic_invite(sender_id, recipient_email, business_id, invitee_id, invite_as_member = false, inviter, message)
    @personal_message = message
    @inviter = inviter
    @business_id = business_id #business of recipient
    @invitee_id = invitee_id #recipient's id in Invite db record
    if !@business_id.nil? && !@invitee_id.nil?
      @business = Business.find(sender_id)
      @invite_company = Business.find(Company.find(business_id).show_business_id)
      mail to: recipient_email, subject: "Join #{@business.name} and Support Local at #{@invite_company.name}."
    end
  end
  def member_invite(sender_id, recipient_email, business_id, invitee_id, invite_as_member = false, inviter, message)
    @personal_message = message
    @inviter = inviter
    @business_id = business_id #business of recipient
    @invitee_id = invitee_id #recipient's id in Invite db record
    if !@business_id.nil? && !@invitee_id.nil?
      @business = Business.find(sender_id)
      @invite_company = Business.find(Company.find(business_id).show_business_id)
      mail to: recipient_email, subject: "Confirm #{@invite_company.name} membership with #{@business.name}"
    end
  end

end
