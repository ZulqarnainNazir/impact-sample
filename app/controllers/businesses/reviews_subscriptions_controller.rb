class Businesses::ReviewsSubscriptionsController < Businesses::BaseController
  def update
    update_resource @business, reviews_subscriptions_params, location: [@business, :reviews], template: :index do |success|
      if success
        ReviewsImportJob.perform_later(@business)
      end
    end
  end

  private

  def reviews_subscriptions_params
    params.require(:business).permit(
      :reviews_automation_cce,
    )
  end
end
