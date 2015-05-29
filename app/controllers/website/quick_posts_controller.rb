class Website::QuickPostsController < Website::BaseController
  def show
    @quick_post = @business.quick_posts.find(params[:id])
  end
end
