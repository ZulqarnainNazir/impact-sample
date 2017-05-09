class InvitesMailer < ApplicationMailer

  def basic_invite(recipient_email, business_id, invitee_id)
    @business_id = business_id #business of recipient
    @invitee_id = invitee_id #recipeint's id in Invite db record
    if !@business_id.nil? && !@invitee_id.nil?
      @business = Company.find(business_id)
      mail to: recipient_email, subject: "Confirm your membership in #{@business.name}."
    end
  end

end