class Website::PostsController < Website::BaseController
  def show
    @post = @business.posts.find(params[:id])
  end
end
