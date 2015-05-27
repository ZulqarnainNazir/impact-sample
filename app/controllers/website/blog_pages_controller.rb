class Website::BlogPagesController < Website::BaseController
  before_action do
    @page = @website.blog_page

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
  end
end
