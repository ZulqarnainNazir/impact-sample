class Website::FeedbacksController < Website::BaseController
  before_action only: new_actions do
    @feedback = @business.feedbacks.where(token: params[:feedback_token]).first!

    if params[:feedback_score]
      @feedback.update(completed_at: Time.now, score: params[:feedback_score])
    else
      @feedback.update(completed_at: Time.now)
    end
  end

  def create
    update_resource @feedback, feedback_params, location: :website_feedback, template: :new
  end

  private

  def feedback_params
    params.require(:feedback).permit(
      :description,
    )
  end
end
