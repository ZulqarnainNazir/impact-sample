class Website::PostsController < Website::BaseController
  def show
    @post = @business.posts.find(params[:id])

    if @website.content_blog_sidebar?
      @sidebar_feed_items = ContentSearch.new(@business).search.page(1).per(4).records
    end
  end
end
