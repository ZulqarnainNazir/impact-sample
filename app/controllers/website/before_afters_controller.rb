class Website::BeforeAftersController < Website::BaseController
  def show
    @before_after = @business.before_afters.find(params[:id])

    if @website.content_blog_sidebar?
      @sidebar_feed_items = ContentSearch.new(@business).search.page(1).per(4).records
    end
  end
end
