module FeedbackConcern
  extend ActiveSupport::Concern

  def render_feedback_form
    if @feedback.review_desired?
      @feedback.build_review(
        business: @business,
        customer_name: @feedback.contact.name,
        customer_email: @feedback.contact.email,
        customer_phone: @feedback.contact.phone,
      )
      render action: :new
    else
      render template: 'website/feedbacks/new'
    end
  end
end
