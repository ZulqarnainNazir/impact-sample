class Businesses::Content::OffersController < Businesses::Content::BaseController
  include PlacementAttributesConcern

  layout 'application'

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
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish] && @offer.published_on < DateTime.now
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      result = page_graph.put_connections @business.facebook_id, 'feed', offer_facebook_params
      @offer.update_column :facebook_id, result['id']
    end
    if params[:draft]
       @offer.published_status = false
       if @offer.save
         redirect_to edit_business_content_offer_path(@business, @offer), notice: "Draft created successfully"
         # go straight to post edit page if saved as draft
         return
       end
    else
       @offer.published_status = true
       redirect_to business_content_feed_path @business if @offer.save
    end
    Offer.__elasticsearch__.refresh_index!
    intercom_event 'created-offer'
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    host = website_host @business.website
    post_path = website_offer_path(@offer)
    @preview_url = @offer.published_status != false ? host + port + post_path : [:website, :generic_post, :preview, :type => "quick_posts", only_path: false, :host => website_host(@business.website), :id => @offer.id]
  end


  def update
    @offer.update(offer_params)
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish] && @offer.published_on < DateTime.now
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      if @offer.facebook_id?
        # Update Post
      else
        result = page_graph.put_connections @business.facebook_id, 'feed', offer_facebook_params
        @offer.update_column :facebook_id, result['id']
      end
    end
    if params[:draft]
       @offer.published_status = false
       if @offer.save
         redirect_to edit_business_content_offer_path(@business, @offer), notice: "Draft created successfully"
         # go straight to post edit page if saved as draft
         return
       end
    else
       @offer.published_status = true
       redirect_to business_content_feed_path @business if @offer.save
    end
    @offer.__elasticsearch__.index_document
    Offer.__elasticsearch__.refresh_index!
  end


  def destroy
    destroy_resource @offer, location: [@business, :content_feed] do |success|
      if success
        begin
          if @business.facebook_id? && @business.facebook_token? && @offer.facebook_id?
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            page_graph.delete_object @offer.facebook_id
          end
        rescue
        end
        Offer.__elasticsearch__.refresh_index!
      end
    end
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

  def offer_facebook_params
    if @offer.published_on > DateTime.now
      {
        caption: truncate(Sanitize.fragment(@offer.offer, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @offer, only_path: false, host: website_host(@business.website)]),
        name: @offer.title,
        picture: @offer.offer_image.try(:attachment_url),
        published: true,
        scheduled_published_time: @offer.published_on,
      }
    else
      {
        backdated_time: @offer.created_at,
        caption: truncate(Sanitize.fragment(@offer.offer, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @offer, only_path: false, host: website_host(@business.website)]),
        name: @offer.title,
        picture: @offer.offer_image.try(:attachment_url),
      }
    end
  end
end
