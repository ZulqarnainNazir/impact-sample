class InvitesMailer < ApplicationMailer
  def basic_invite(sender_id, recipient_email, business_id, invitee_id, invite_as_member = false, inviter, message)
    @personal_message = message
    @inviter = inviter
    @business_id = business_id #business of recipient
    @invitee_id = invitee_id #recipient's id in Invite db record
    if !@business_id.nil? && !@invitee_id.nil?
      @business = Business.find(sender_id)
      @invitee = Contact.find(invitee_id)
      @invite_company = Business.find(Company.find(business_id).show_business_id)
      mail to: recipient_email, subject: "#{@invitee.first_name}, #{@business.name} wants you to join them in supporting local!"
    end
  end

  def member_invite(sender_id, recipient_email, business_id, invitee_id, invite_as_member = false, inviter, message)
    @personal_message = message
    @inviter = inviter
    @business_id = business_id #business of recipient
    @invitee_id = invitee_id #recipient's id in Invite db record
    if !@business_id.nil? && !@invitee_id.nil?
      @business = Business.find(sender_id)
      @invitee = Contact.find(invitee_id)
      @invite_company = Business.find(Company.find(business_id).show_business_id)
      subject = @business.website_url == "http://" ? "#{@invitee.first_name}, your free account for #{@invite_company.name} is ready for you!" : "#{@invitee.first_name}, your free account for #{@invite_company.name} on #{@business.website_url.gsub("http://", "")} is ready for you!"
      mail to: recipient_email, subject: subject
    end
  end

end
