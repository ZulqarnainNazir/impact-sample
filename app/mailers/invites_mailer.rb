class InvitesMailer < ApplicationMailer
  def quick_invite(invite, sender)
    @personal_message = invite.message
    @invitee_id = invite.invitee.id
    @business = sender
    mail to: invite.invitee.email, subject: "#{@business.name} wants you to join them in supporting local!"
  end
  def basic_invite(invite, sending_bus)
    @invite = invite
    @personal_message = invite.message
    @inviter = invite.inviter
    @business_id = invite.company_id #business of recipient
    @invitee_id = invite.invitee_id #recipient's id in Invite db record
    if !@business_id.nil? && !@invitee_id.nil?
      @business = sending_bus
      @invitee = Contact.find(@invitee_id)
      @invite_company = Business.find(Company.find(@business_id).show_business_id)
      mail to: invite.invitee.email, subject: "#{@invitee.first_name}, #{@business.name} wants you to join them in supporting local!"
    elsif !@invitee_id.nil?
      @business = sending_bus
      @invitee = Contact.find(@invitee_id)
      subject = "#{@invitee.first_name.length > 0 ? "#{@invitee.first_name}, " : ""}#{@business.name} wants you to join them in supporting local!"
      mail to: invite.invitee.email, subject: subject
    end

  end

  def member_invite(invite, sending_bus)
    @invite = invite
    @personal_message = invite.message
    @inviter = invite.inviter
    @business_id = invite.company_id #business of recipient
    @invitee_id = invite.invitee_id #recipient's id in Invite db record
    if !@business_id.nil? && !@invitee_id.nil?
      @business = sending_bus
      @invitee = Contact.find(invite.invitee_id)
      @invite_company = Business.find(Company.find(@business_id).show_business_id)
      subject = @business.website_url == "http://" ? "#{@invitee.first_name}, your free account for #{@invite_company.name} is ready for you!" : "#{@invitee.first_name}, your free account for #{@invite_company.name} on #{@business.website_url.gsub("http://", "")} is ready for you!"
      mail to: invite.invitee.email, subject: subject
    elsif !@invitee_id.nil?
      @business = sending_bus
      @invitee = Contact.find(invite.invitee_id)
      if @business.website_url == "http://"
        subject = "#{@invitee.first_name.length > 0 ? "#{@invitee.first_name}, your" : "Your"}, your free account is ready for you!"
      else
        subject = "#{@invitee.first_name.length > 0 ? "#{@invitee.first_name}, your" : "Your"} free account on #{@business.website_url.gsub("http://", "")} is ready for you!"
      end
      mail to: invite.invitee.email, subject: subject
    end
  end

  # def member_invite_2(sender_id, recipient_email, business_id, invitee_id, invite_as_member = false, inviter, message)
  def member_invite_2(invite, sending_bus)
    @invite = invite
    @personal_message = invite.message
    @inviter = invite.inviter
    @business_id = invite.company_id #business of recipient
    @invitee_id = invite.invitee_id #recipient's id in Invite db record
    if !@business_id.nil? && !@invitee_id.nil?
      @business = sending_bus
      @invitee = Contact.find(invite.invitee_id)
      @invite_company = Business.find(Company.find(@business_id).show_business_id)
      subject = "Subject: Confirm #{@invite.company.try(:name) || "your"} membership with #{@business.name}"
      mail to: invite.invitee.email, subject: subject
    elsif !@invitee_id.nil?
      @business = sending_bus
      @invitee = Contact.find(invite.invitee_id)
      subject = "Subject: Confirm your membership with #{@business.name}"
      mail to: invite.invitee.email, subject: subject
    end
  end
end
