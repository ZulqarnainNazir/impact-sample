class Website::ReviewsController < Website::BaseController
  before_action only: new_actions do
    @feedback = @business.feedbacks.where(token: params[:feedback_token]).first!

    if params[:feedback_score]
      @feedback.update(completed_at: Time.now, score: params[:feedback_score].to_i)
    else
      @feedback.update(completed_at: Time.now)
    end

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
    @feedback.assign_attributes(feedback_params)

    if @feedback.save
      intercom_event 'created-review', {
        user_email: @feedback.customer.email,
        customer_name: @feedback.customer.email,
        customer_phone: @feedback.customer.email,
        customer_email: @feedback.customer.email,
        serviced_at: @feedback.serviced_at,
        feedback_score: @feedback.score,
        quality_rating: @feedback.review.quality_rating,
        service_rating: @feedback.review.service_rating,
        value_rating: @feedback.review.value_rating,
        overall_rating: @feedback.review.overall_rating,
        review_title: @feedback.review.title,
      }

      if @business.automated_reviews_publishing && @feedback.review.overall_rating >= @business.automated_reviews_publishing
        @feedback.review.update_column :published, true
      end

      if @business.automated_reviews_publishing && @feedback.review.overall_rating >= @business.automated_reviews_publishing
        redirect_to [:website_share, review_url: website_review_url(@feedback.review)]
      elsif !@business.automated_reviews_publishing && @feedback.review.overall_rating >= 4.0
        redirect_to :website_share
      else
        redirect_to :website_reviews, notice: t('.notice')
      end
    else
      flash.now.alert = t('.alert')
      render :new
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
