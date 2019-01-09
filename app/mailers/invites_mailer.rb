class InvitesMailer < ApplicationMailer
  layout 'mailer_theme_two'

  def quick_invite(invite, sender)
    unless invite.invitee.opted_out?
      @personal_message = invite.message
      @invitee_id = invite.invitee.id
      @business = sender
      track extra: {business_id: @business.id}
      mail to: invite.invitee.email, from: "#{@business.name} <#{Rails.application.secrets.invite_email}>", subject: "Recommended by #{@business.name} in #{@business.location.city_and_state}"
    end
  end

  def basic_invite(invite, sending_bus)
    unless invite.invitee.opted_out?
      @invite = invite
      @personal_message = invite.message
      @inviter = invite.inviter
      @business_id = invite.company_id #business of recipient
      @invitee_id = invite.invitee_id #recipient's id in Invite db record
      if !@business_id.nil? && !@invitee_id.nil?
        @business = sending_bus
        @invitee = Contact.find(@invitee_id)
        @invite_company = Business.find(Company.find(@business_id).show_business_id)
        track extra: {business_id: @business.id}
        mail to: invite.invitee.email, from: "#{@business.name} <#{Rails.application.secrets.invite_email}>", subject: "Recommended by #{@business.name} in #{@business.location.city_and_state}"
      elsif !@invitee_id.nil?
        @business = sending_bus
        @invitee = Contact.find(@invitee_id)
        subject = "Recommended by #{@business.name} in #{@business.location.city_and_state}"
        track extra: {business_id: @business.id}
        mail to: invite.invitee.email, from: "#{@business.name} <#{Rails.application.secrets.invite_email}>", subject: subject
      end
    end
  end

  def member_invite(invite, sending_bus)
    unless invite.invitee.opted_out?
      @invite = invite
      @personal_message = invite.message
      @inviter = invite.inviter
      @business_id = invite.company_id #business of recipient
      @invitee_id = invite.invitee_id #recipient's id in Invite db record
      if !@business_id.nil? && !@invitee_id.nil?
        @business = sending_bus
        @invitee = Contact.find(invite.invitee_id)
        @invite_company = Company.find(@business_id)
        subject = ""
        if !@invitee.first_name.blank? && !@invite_company.nil? && !@invite_company.name.blank?
          subject = "#{@invitee.first_name}, let's cross-promote to reach more people for #{@invite_company.name} and support local!"
        elsif @invitee.first_name.blank? && !@invite_company.nil? && !@invite_company.name.blank?
          subject = "Let's cross-promote to reach more people for #{@invite_company.name} and support local!"
        else
          subject = "Let's cross-promote to reach more people and support local!"
        end

        # subject = @business.website_url == "http://" ? "#{@invitee.first_name}, equip us to promote #{@invite_company.name}!" : "Equip us to promote #{@invite_company.name}!"
        track extra: {business_id: @business.id}
        mail to: invite.invitee.email, from: "#{@business.name} <#{Rails.application.secrets.invite_email}>", subject: subject
      elsif !@invitee_id.nil?
        @business = sending_bus
        @invitee = Contact.find(invite.invitee_id)
        subject = "#{@invitee.first_name.length > 0 ? "#{@invitee.first_name}, let's cross-promote to reach more people and support local" : "Let's cross-promote to reach more people and support local"}!"
        track extra: {business_id: @business.id}
        mail to: invite.invitee.email, from: "#{@business.name} <#{Rails.application.secrets.invite_email}>", subject: subject
      end
    end
  end

  # def member_invite_2(sender_id, recipient_email, business_id, invitee_id, invite_as_member = false, inviter, message)
  def member_invite_2(invite, sending_bus)
    unless invite.invitee.opted_out?
      @invite = invite
      @personal_message = invite.message
      @inviter = invite.inviter
      @business_id = invite.company_id #business of recipient
      @invitee_id = invite.invitee_id #recipient's id in Invite db record
      if !@business_id.nil? && !@invitee_id.nil?
        @business = sending_bus
        @invitee = Contact.find(invite.invitee_id)
        @invite_company = Company.find(@business_id)
        subject = "Free marketing for #{@invite_company.try(:name) || "you"} in and around #{@invite_company.location.city_and_state}"
        mail to: invite.invitee.email, from: "#{@business.name} <#{Rails.application.secrets.invite_email}>", subject: subject
      elsif !@invitee_id.nil?
        @business = sending_bus
        @invitee = Contact.find(invite.invitee_id)
        subject = "Free marketing for you"
        track extra: {business_id: @business.id}
        mail to: invite.invitee.email, from: "#{@business.name} <#{Rails.application.secrets.invite_email}>", subject: subject
      end
    end
  end
end
