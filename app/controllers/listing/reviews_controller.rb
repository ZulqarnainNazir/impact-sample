class Listing::ReviewsController < Listing::BaseController
  layout :resolve_layout

  include ApplicationHelper
  include ContentSearchConcern
  include FeedbackConcern

  before_action do
    @business = Business.listing_lookup(params[:lookup])

    @content_feed_widget = ContentFeedWidget.new  # empty "fake" content widget in order to display business content
    @content_feed_widget.business = @business
    @content_feed_widget.max_items = 12
    @posts = get_content(
      business: @content_feed_widget.business,
      embed: @content_feed_widget,
      content_types: ALL_CONTENT_TYPES,
      content_category_ids: @content_feed_widget.content_category_ids.to_s.split(' ').map(&:to_i),
      content_tag_ids: @content_feed_widget.content_tag_ids.to_s.split(' ').map(&:to_i),
      order: 'desc',
      page: params[:page],
      per_page: @content_feed_widget.max_items
    )
  end

  before_action only: new_actions do
    @feedback = @business.feedbacks.where(token: params[:feedback_token]).first!
    @form_url = listing_create_review_path(@business.generate_listing_segment)

    if params[:feedback_score]
      @feedback.update(completed_at: Time.now, score: params[:feedback_score].to_i)
    else
      @feedback.update(completed_at: Time.now)
    end
  end

  before_action only: :new do
    render_feedback_form
  end

  before_action only: :create do
    render_feedback_form(with_render: false)
  end

  before_action only: [:show] do
    @review = @business.reviews.published.find(params[:id])
    @truncate_rev = false;
    @hide_link = true;
  end

  def index
    @reviews = @business.reviews.published.order(reviewed_at: :desc).page(params[:page]).per(20)
    @locable_business = LocableBusiness.find_by_id(@business.cce_id) if @business.cce_id? rescue nil
    @truncate_rev = false
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
        overall_rating: @feedback&.review&.overall_rating,
      }

      if @business.automated_reviews_publishing && @feedback.review.present? && (@feedback.review.overall_rating >= @business.automated_reviews_publishing)
        @feedback.review.update_column :published, true
        redirect_to listing_share_path(@business.generate_listing_segment, review_url: listing_path_review_url(@business, @feedback.review))
      elsif !@business.automated_reviews_publishing && @feedback.review.present? && @feedback.review.overall_rating >= 4.0
        redirect_to listing_share_path(@business.generate_listing_segment)
      elsif @feedback.review.present?
        redirect_to :action => 'index', notice: 'Thanks for leaving your Review.'
      else
        redirect_to :action => 'index', notice: 'Thanks for leaving your Feedback.'
      end
    else
      flash.now.alert = t('.alert')
      render :new
    end
  end

  def new
  end

  private

  def resolve_layout
    case action_name
    when "new"
      "bare_listing"
    else
      "listing"
    end
  end

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
