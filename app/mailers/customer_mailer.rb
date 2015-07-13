class CustomerMailer < ApplicationMailer
  include WebsiteHelper

  def feedback(feedback)
    @feedback = feedback
    @business = feedback.customer.business
    @website_host = website_host(@business.website)
    mail to: @feedback.customer.email, subject: "Feedback on your experience with #{@business.name}"
  end
end
