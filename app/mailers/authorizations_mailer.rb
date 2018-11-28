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
    mail(to: @authorization.user.email, reply_to: @contact_message.customer_email)
  end

  def review_notification(authorization, review)
    @authorization = authorization
    @review = review
    mail to: @authorization.user.email, layout: 'mailer_theme_three'
  end

  def contact_form_submission_notification(authorization, form_submission)
    @authorization = authorization
    @form_submission = form_submission

    # mail(to: @authorization.user.email, reply_to: "ryan+hardcode@locable.com", layout: 'mailer_theme_three')
    # mail(to: @authorization.user.email, reply_to: 'ryan+hardcode@locable.com')

    @reply = ""
    @form_submission.form_submission_values.each do | value |
      if value.contact_form_form_field.label == 'Email'
        @reply = value.value
      end
    end

    if @reply != ""
      mail(to: @authorization.user.email, reply_to: @reply,  layout: 'mailer_theme_three')
    else
      mail(to: @authorization.user.email, layout: 'mailer_theme_three')
    end
  end

end
