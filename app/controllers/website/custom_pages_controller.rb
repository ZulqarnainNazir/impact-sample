class Website::CustomPagesController < Website::BaseController
  before_action do
    @page = @website.webpages.custom.find_by_pathname!(params[:id])

    if !@page.active? && !@business.owners.include?(current_user) && false
      raise ActiveRecord::RecordNotFound
    end

    if @page.sidebar_feed_block
      @sidebar_feed_items = ContentSearch.new(@business, params[:query]).search.page(1).per(@page.sidebar_feed_block.items_limit).records
    end
  end
end
