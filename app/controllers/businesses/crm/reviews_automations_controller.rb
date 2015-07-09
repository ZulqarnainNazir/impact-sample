class Businesses::Crm::ReviewsAutomationsController < Businesses::BaseController
  def update
    update_resource @business, reviews_automation_params, location: [@business, :crm_reviews]
  end

  private

  def reviews_automation_params
    params.require(:business).permit(
      :automated_reviews_publishing,
    )
  end
end
