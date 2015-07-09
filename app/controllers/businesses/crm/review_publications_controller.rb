class Businesses::Crm::ReviewPublicationsController < Businesses::BaseController
  before_action do
    @review = @business.reviews.find(params[:review_id])
  end

  def create
    toggle_resource_boolean_on @review, :published, location: [@business, :crm, params[:page].present? ? :reviews : @review].compact
  end

  def destroy
    toggle_resource_boolean_off @review, :published, location: [@business, :crm, params[:page].present? ? :reviews : @review].compact
  end
end
