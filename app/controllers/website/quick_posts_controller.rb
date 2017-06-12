class Website::QuickPostsController < Website::BaseController
  def show
    @quick_post = @business.quick_posts.find(params[:id])
    generic_params = @quick_post.to_generic_param
    if params[:uuid] =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
      generic_params[:uuid] = params[:uuid]
    end
    redirect_to website_generic_post_path(generic_params), status: 301
  end
end
