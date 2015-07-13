# Preview all emails at http://localhost:3000/rails/mailers/customer_mailer_preview
class CustomerMailerPreview < ActionMailer::Preview
  def feedback
    CustomerMailer.feedback(Feedback.last)
  end
end
