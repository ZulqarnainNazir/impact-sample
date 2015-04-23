class Website::GalleriesController < Website::BaseController
  def show
    @gallery = @business.galleries.find(params[:id])
  end
end
