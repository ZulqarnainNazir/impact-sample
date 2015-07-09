class Businesses::Crm::FeedbacksAutomationsController < Businesses::BaseController
  def update
    update_resource @business, feedbacks_automation_params, location: [@business, :crm_feedbacks]
  end

  private

  def feedbacks_automation_params
    params.require(:business).permit(
      :automated_feedbacks_publishing,
    )
  end
end
