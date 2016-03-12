class Website::QuickPostsController < Website::BaseController
  def show
    @quick_post = @business.quick_posts.find(params[:id])
    redirect_to website_generic_post_path(@quick_post.to_generic_param), status: 301
  end
end
