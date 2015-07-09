class Businesses::Crm::ReviewsController < Businesses::BaseController
  before_action only: member_actions do
    @review = @business.reviews.find(params[:id])
  end

  def index
    @reviews = @business.reviews.page(params[:page]).per(20)
  end
end
