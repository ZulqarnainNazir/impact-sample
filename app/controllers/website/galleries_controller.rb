class Website::GalleriesController < Website::BaseController
  def index
    @galleries = @business.galleries.order(created_at: :desc)
  end

  def show
    @gallery = @business.galleries.find(params[:id])
    redirect_to website_generic_post_path(@gallery.to_generic_param), status: 301
  end
end
