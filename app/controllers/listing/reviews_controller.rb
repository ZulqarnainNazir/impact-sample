class Listing::ReviewsController < ApplicationController
  include ApplicationHelper
  before_action do
    @business = Business.listing_lookup(params[:lookup])
  end

  before_action only: new_actions do
    @feedback = @business.feedbacks.where(token: params[:feedback_token]).first!

    if params[:feedback_score]
      @feedback.update(completed_at: Time.now, score: params[:feedback_score].to_i)
    else
      @feedback.update(completed_at: Time.now)
    end

    @feedback.build_review(
      business: @business,
      customer_name: @feedback.contact.name,
      customer_email: @feedback.contact.email,
      customer_phone: @feedback.contact.phone,
    )
  end

  before_action only: [:show] do
    @review = @business.reviews.published.find(params[:id])
  end

  def index
    @reviews = @business.reviews.published.order(reviewed_at: :desc).page(params[:page]).per(20)
    @locable_business = LocableBusiness.find_by_id(@business.cce_id) if @business.cce_id? rescue nil
  end

  def create
    @feedback.assign_attributes(feedback_params)

    if @feedback.save
      intercom_event 'created-review', {
        user_email: @feedback.contact.email,
        customer_name: @feedback.contact.email,
        customer_phone: @feedback.contact.email,
        customer_email: @feedback.contact.email,
        serviced_at: @feedback.serviced_at,
        feedback_score: @feedback.score,
        overall_rating: @feedback.review.overall_rating,
      }

      if @business.automated_reviews_publishing && @feedback.review.overall_rating >= @business.automated_reviews_publishing
        @feedback.review.update_column :published, true
      end

      if @business.automated_reviews_publishing && @feedback.review.overall_rating >= @business.automated_reviews_publishing
        redirect_to listing_share_path(@business.generate_listing_segment, review_url: listing_path_review_url(@business, @feedback.review))
      elsif !@business.automated_reviews_publishing && @feedback.review.overall_rating >= 4.0
        redirect_to listing_share_path(@business.generate_listing_segment)
      else
        redirect_to :action => 'index', notice: t('.notice')
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
        :company_id,
      ],
    ).tap do |safe_params|
      if safe_params[:review_attributes]
        safe_params[:review_attributes][:serviced_at] = safe_params[:serviced_at]
      end
    end
  end
end
