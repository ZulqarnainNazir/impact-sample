class AuthorizationsMailer < ApplicationMailer
  def owner_welcome(authorization)
    @authorization = authorization
    mail to: @authorization.user.email
  end

  def contact_message_notification(authorization, contact_message)
    @authorization = authorization
    @contact_message = contact_message
    mail to: @authorization.user.email
  end
end
