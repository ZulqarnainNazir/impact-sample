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
        Offer.__elasticsearch__.refresh_index!
        intercom_event 'created-offer'
      end
    end
  end

  def update
    update_resource @offer, offer_params, location: [@business, :content_feed] do |success|
      if success
        Offer.__elasticsearch__.refresh_index!
      end
    end
  end

  def destroy
    destroy_resource @offer, location: [@business, :content_feed] do |success|
      if success
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
end
