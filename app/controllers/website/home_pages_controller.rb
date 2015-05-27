class Website::HomePagesController < Website::BaseController
  before_action do
    @page = @website.home_page

    if !@page
      @redirect = @website.redirects.find_by_from_path(request.path)

      if @redirect
        redirect_to @redirect.to_path, status: 301
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    if @page.feed_block
      @feed_items = ContentSearch.new(@business).search.page(1).per(@page.feed_block.items_limit).records
    end

    if @page.sidebar_feed_block
      @sidebar_feed_items = ContentSearch.new(@business).search.page(1).per(@page.sidebar_feed_block.items_limit).records
    end

    if @page.sidebar_events_block
      @sidebar_events = ContentSearch.new(@business, models: [Event]).search.page(1).per(@page.sidebar_events_block.items_limit).records
    end
  end
end
