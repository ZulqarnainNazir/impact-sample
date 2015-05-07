class Website::QuickPostsController < Website::BaseController
  def show
    @quick_post = @business.quick_posts.find(params[:id])

    if @website.content_blog_sidebar?
      @sidebar_feed_items = ContentSearch.new(@business).search.page(1).per(4).records
    end
  end
end
