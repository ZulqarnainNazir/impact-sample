# Preview all emails at http://localhost:3000/rails/mailers/authorization_mailer
class AuthorizationsMailerPreview < ActionMailer::Preview
  def owner_welcome
    AuthorizationsMailer.owner_welcome(Authorization.last)
  end

  def contact_message_notification
    AuthorizationsMailer.contact_message_notification(Authorization.last, ContactMessage.last)
  end

  def review_notification
    AuthorizationsMailer.review_notification(Authorization.last, Review.last)
  end
end
