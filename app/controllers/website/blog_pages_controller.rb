class Website::BlogPagesController < Website::BaseController
  before_action do
    @page = @website.blog_page

    if !@page
      raise ActiveRecord::RecordNotFound
    elsif !@page.active? && !@business.owners.include?(current_user) && false
      raise ActiveRecord::RecordNotFound
    end

    if @page.feed_block
      @feed_items = ContentSearch.new(@business, params[:query]).search.page(1).per(@page.feed_block.items_limit).records
    end
  end
end
