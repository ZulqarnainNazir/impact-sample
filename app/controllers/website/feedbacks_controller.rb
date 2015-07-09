class Website::FeedbacksController < Website::BaseController
  before_action only: new_actions do
    @feedback = @business.feedbacks.incomplete.where(token: params[:feedback_token]).first!
    @feedback.completed_at = Time.now
  end

  def create
    update_resource @feedback, feedback_params, location: :website_feedback, template: :new
  end

  private

  def feedback_params
    params.require(:feedback).permit(
      :description,
      :score,
    )
  end
end
