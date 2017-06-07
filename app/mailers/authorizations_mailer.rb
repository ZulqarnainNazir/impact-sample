class AuthorizationsMailer < ApplicationMailer
  def owner_welcome(authorization)
    @authorization = authorization
    mail to: @authorization.user.email
  end

  def welcome(authorization)
    @authorization = authorization
    mail to: @authorization.user.email
  end

  def contact_message_notification(authorization, contact_message)
    @authorization = authorization
    @contact_message = contact_message
    mail to: @authorization.user.email
  end

  def review_notification(authorization, review)
    @authorization = authorization
    @review = review
    mail to: @authorization.user.email
  end

  def contact_form_submission_notification(authorization, form_submission)
    @authorization = authorization
    @form_submission = form_submission
    mail to: @authorization.user.email
  end
end
