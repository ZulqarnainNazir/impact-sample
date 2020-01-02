module FeedbackConcern
  extend ActiveSupport::Concern

  def render_feedback_form(with_render: true)
    if @feedback.review_desired?
      @feedback.build_review(
        business: @business,
        customer_name: @feedback.contact.name,
        customer_email: @feedback.contact.email,
        customer_phone: @feedback.contact.phone,
      )
      render action: :new if with_render
    else
      if @feedback.score == 0
        redirect_to listing_path(@business), notice: "Thanks for letting us know. You will not recieve further requests for feedback." if with_render
      else
        # TODO - this partial should be moved to listings/
        render template: 'website/feedbacks/new' if with_render
      end
    end
  end
end
