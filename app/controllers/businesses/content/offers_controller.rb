class Businesses::Content::OffersController < Businesses::Content::BaseController
  before_action only: new_actions do
    @offer = @business.offers.new
  end

  before_action only: member_actions do
    @offer = @business.offers.find(params[:id])
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
      :title,
      :offer,
      :description,
    )
  end
end
