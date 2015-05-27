class Website::OffersController < Website::BaseController
  def show
    @offer = @business.offers.find(params[:id])

    if @website.content_blog_sidebar?
      @sidebar_feed_items = ContentSearch.new(@business).search.page(1).per(4).records
    end

    if @website.events_sidebar?
      @sidebar_events = ContentSearch.new(@business, models: [Event]).search.page(1).per(4).records
    end
  end
end
