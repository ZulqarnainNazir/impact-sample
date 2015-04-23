class Website::GalleriesController < Website::BaseController
  def index
    @galleries = @business.galleries.order(created_at: :desc)
  end

  def show
    @gallery = @business.galleries.find(params[:id])
  end
end
