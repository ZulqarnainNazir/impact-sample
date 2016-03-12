class Website::PostsController < Website::BaseController
  def show
    @post = @business.posts.find(params[:id])
    redirect_to website_generic_post_path(@post.to_generic_param), status: 301
  end
end
