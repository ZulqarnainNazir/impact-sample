class Website::OffersController < Website::BaseController
  def show
    @offer = @business.offers.find(params[:id])
    redirect_to website_generic_post_path(@offer.to_generic_param), status: 301
  end
end
