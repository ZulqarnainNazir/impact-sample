class CustomerMailer < ApplicationMailer
  include WebsiteHelper

  def feedback(feedback)
    unless feedback.completed_at?
      @feedback = feedback
      @business = feedback.customer.business
      @website_host = website_host(@business.website)
      mail to: @feedback.customer.email, subject: "Feedback on your experience with #{@business.name}"
    end
  end
end
