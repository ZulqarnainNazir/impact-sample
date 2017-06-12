class Website::PostsController < Website::BaseController
  def show
    @post = @business.posts.find(params[:id])
    generic_params = @post.to_generic_param
    if params[:uuid] =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
      generic_params[:uuid] = params[:uuid]
    end
    redirect_to website_generic_post_path(generic_params), status: 301
  end
end
