class Businesses::Crm::ReviewInvitationsController < Businesses::BaseController
  before_action do
    @feedback = @business.feedbacks.find(params[:feedback_id])
  end

  def create
    CustomerMailer.feedback(@feedback).deliver_later
    redirect_to :back, notice: "We’ve sent a request for feedback to #{@feedback.customer.email}"
  end
end
