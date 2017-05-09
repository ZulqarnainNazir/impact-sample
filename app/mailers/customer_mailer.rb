class CustomerMailer < ApplicationMailer
  include WebsiteHelper
  include ApplicationHelper
  add_template_helper(ApplicationHelper)

  def feedback(feedback)
    unless feedback.completed_at?
      @feedback = feedback
      @business = feedback.contact.business
      @website_host = website_host(@business.website)
      track extra: {business_id: @business.id}
      mail to: @feedback.contact.email, from: "#{@business.name} <#{Rails.application.secrets.support_email}>", subject: "Feedback on your experience with #{@business.name}"
    end
  end
end
