class Website::OffersController < Website::BaseController
  def show
    @offer = @business.offers.find(params[:id])
  end
end
