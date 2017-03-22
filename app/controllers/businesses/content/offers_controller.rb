class Businesses::Content::OffersController < Businesses::Content::BaseController
  include PlacementAttributesConcern

  layout 'business_reduced'

  before_action only: new_actions do
    @offer = @business.offers.new
  end

  before_action only: member_actions do
    @offer = @business.offers.find(params[:id])
  end

  def clone
    cloned_offer = @business.offers.find(params[:id])
    cloned_attributes = cloned_offer.attributes.slice(*%w[title description offer terms offer_code])
    @offer = @business.offers.new(cloned_attributes)
    @offer.offer_image_placement_attributes = { image_id: cloned_offer.offer_image.try(:id) }
    render :new
  end

  def create
    @offer = Offer.new(offer_params)
    @offer.business = @business
    if params[:draft].present?
      @offer.published_status = false
    else
      @offer.published_status = true
    end
    respond_to do |format|
      if @offer.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to edit_business_content_offer_path(@business, @offer), notice: "Draft created successfully" } if params[:draft].present? 
        format.html { redirect_to new_business_content_offer_share_path(@business, @offer), notice: "Post created successfully" } if !params[:draft].present?
      else
        format.html { render :action => "new" }
      end
    end
    Offer.__elasticsearch__.refresh_index!
    intercom_event 'created-offer'
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    host = website_host @business.website
    post_path = website_offer_path(@offer)
    @preview_url = @offer.published_status != false ? host + port + post_path : [:website, :generic_post, :preview, :type => "quick_posts", only_path: false, :host => website_host(@business.website), protocol: :http, :id => @offer.id]
  end


  def update
    @offer.update(offer_params)
    if params[:draft].present?
      @offer.published_status = false
    else
      @offer.published_status = true
    end
    respond_to do |format|
      if @offer.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to edit_business_content_offer_path(@business, @offer), notice: "Draft created successfully" } if params[:draft].present?
        format.html { redirect_to business_content_feed_path @business } if !params[:draft].present?
      else
        format.html { render :action => "edit" }
      end
    end

    @offer.__elasticsearch__.index_document
    Offer.__elasticsearch__.refresh_index!
  end


  def destroy
    destroy_resource @offer, location: [@business, :content_feed] do |success|
      if success
        Offer.__elasticsearch__.refresh_index!
      end
    end
  end

  def sharing_insights
    @offer = Offer.find(params[:offer_id])
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end

  private

  def offer_params
    params.require(:offer).permit(
      :coupon,
      :description,
      :kind,
      :meta_description,
      :offer,
      :offer_code,
      :published_on,
      :published_time,
      :terms,
      :title,
      :valid_until,
      content_category_ids: [],
      content_tag_ids: [],
      offer_image_placement_attributes: placement_attributes,
      main_image_placement_attributes: placement_attributes,
    ).deep_merge(
      offer_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
      main_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    ).tap do |safe_params|
      safe_params[:content_category_ids] = [] unless safe_params[:content_category_ids]
      safe_params[:content_tag_ids] = [] unless safe_params[:content_tag_ids]
    end
  end
end
