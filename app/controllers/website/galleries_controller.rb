class Website::GalleriesController < Website::BaseController
  def index
    @galleries = @business.galleries.order(created_at: :desc)
  end

  def show
    @gallery = @business.galleries.find(params[:id])
    generic_params = @gallery.to_generic_param
    if params[:uuid] =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
      generic_params[:uuid] = params[:uuid]
    end
    redirect_to website_generic_post_path(generic_params), status: 301
  end
end
