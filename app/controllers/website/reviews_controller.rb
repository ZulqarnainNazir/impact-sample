class Website::ReviewsController < Website::BaseController
  before_action only: new_actions do
    @feedback = @business.feedbacks.incomplete.where(token: params[:feedback_token]).first!
    @feedback.score = params[:feedback_score]
    @feedback.build_review(
      business: @business,
      customer_name: @feedback.customer.name,
      customer_email: @feedback.customer.email,
      customer_phone: @feedback.customer.phone,
    )
  end

  before_action only: member_actions do
    @review = @business.reviews.published.find(params[:id])
  end

  def index
    @reviews = @business.reviews.published.order(reviewed_at: :desc).page(params[:page]).per(20)
    @locable_business = LocableBusiness.find_by_id(@business.cce_id) if @business.cce_id?
  end

  def create
    create_resource @feedback, feedback_params, location: :website_reviews do |success|
      if success && @business.automated_reviews_publishing && @feedback.review.overall_rating >= @business.automated_reviews_publishing
        @feedback.review.update_column :published, true
      end
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(
      :serviced_at,
      :score,
      :description,
      review_attributes: [
        :description,
        :overall_rating,
        :quality_rating,
        :service_rating,
        :title,
        :value_rating,
      ],
    ).tap do |safe_params|
      if safe_params[:review_attributes]
        safe_params[:review_attributes][:serviced_at] = safe_params[:serviced_at]
      end
    end
  end
end
