class CustomerMailer < ApplicationMailer
  include WebsiteHelper

  def feedback(feedback)
    unless feedback.completed_at?
      @feedback = feedback
      @business = feedback.contact.business
      @website_host = website_host(@business.website)
      mail to: @feedback.contact.email, from: "#{@business.name} <#{Rails.application.secrets.support_email}>", subject: "Feedback on your experience with #{@business.name}"
    end
  end
end
