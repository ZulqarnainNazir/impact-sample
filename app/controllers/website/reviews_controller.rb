class Website::ReviewsController < Website::BaseController
  before_action only: new_actions do
    @review = @business.reviews.new
  end

  before_action only: member_actions do
    @review = @business.reviews.published.find(params[:id])
  end

  def index
    @reviews = @business.reviews.published.order(reviewed_at: :desc).page(params[:page]).per(20)
    @locable_business = LocableBusiness.find_by_id(@business.cce_id) if @business.cce_id?
  end

  def create
    create_resource [:website, @review], review_params, location: :website_reviews do |success|
      if success && @business.automated_reviews_publishing && @review.overall_rating >= @business.automated_reviews_publishing
        @review.update_column :published, true
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(
      :customer_email,
      :customer_name,
      :customer_phone,
      :description,
      :overall_rating,
      :quality_rating,
      :service_rating,
      :title,
      :value_rating,
    )
  end
end
