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
    @existing_offer = @business.offers.find(params[:id])
    @offer = @business.offers.new
    @offer.title = @existing_offer.title
    @offer.description = @existing_offer.description
    @offer.offer = @existing_offer.offer
    @offer.terms = @existing_offer.title
    @offer.terms = @existing_offer.terms
    @offer.offer_code = @existing_offer.offer_code
    @offer.offer_image_placement_attributes = { image_id: @existing_offer.offer_image.try(:id) }
    render :new
  end

  def create
    create_resource @offer, offer_params, location: [@business, :content_feed]
  end

  def update
    update_resource @offer, offer_params, location: [@business, :content_feed]
  end

  def destroy
    destroy_resource @offer, location: [@business, :content_feed]
  end

  private

  def offer_params
    params.require(:offer).permit(
      :kind,
      :description,
      :offer,
      :offer_code,
      :terms,
      :title,
      :valid_until,
      :coupon,
      offer_image_placement_attributes: placement_attributes,
    ).deep_merge(
      offer_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    )
  end
end
