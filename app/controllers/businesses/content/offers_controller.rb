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
    create_resource @offer, offer_params, location: [@business, :content_feed] do |success|
      if success
        if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
          page_graph = Koala::Facebook::API.new(@business.facebook_token)
          result = page_graph.put_connections @business.facebook_id, 'feed', offer_facebook_params
          @offer.update_column :facebook_id, result['id']
        end
        Offer.__elasticsearch__.refresh_index!
        intercom_event 'created-offer'
      end
    end
  end

  def update
    update_resource @offer, offer_params, location: [@business, :content_feed] do |success|
      if success
        if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
          page_graph = Koala::Facebook::API.new(@business.facebook_token)
          if @offer.facebook_id?
            page_graph.put_connections @offer.facebook_id, offer_facebook_params
          else
            result = page_graph.put_connections @business.facebook_id, 'feed', offer_facebook_params
            @offer.update_column :facebook_id, result['id']
          end
        end
        Offer.__elasticsearch__.refresh_index!
      end
    end
  end

  def destroy
    destroy_resource @offer, location: [@business, :content_feed] do |success|
      if success
        if @business.facebook_id? && @business.facebook_token? && @offer.facebook_id?
          page_graph = Koala::Facebook::API.new(@business.facebook_token)
          page_graph.delete_object @offer.facebook_id
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
    )
  end

  def offer_facebook_params
    {
      backdated_time: @offer.created_at,
      caption: Sanitize.fragment(@offer.offer, Sanitize::Config::DEFAULT),
      link: url_for([:website, @offer, only_path: false, host: website_host(@business.website)]),
      name: @offer.title,
      picture: @offer.offer_image.try(:attachment_url),
    }
  end
end
