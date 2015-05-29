class Website::HomePagesController < Website::BaseController
  before_action do
    @page = @website.home_page or raise ActiveRecord::RecordNotFound

    if @page.feed_block
      @feed_items = ContentBlogSearch.new(@business).search.page(1).per(@page.feed_block.items_limit).records
    end
  end
end
