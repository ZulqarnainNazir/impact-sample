class Website::BlogPagesController < Website::BaseController
  before_action do
    @page = @website.blog_page or raise ActiveRecord::RecordNotFound
    @feed_items = ContentBlogSearch.new(@business).search.page(1).per(@page.feed_block.items_limit).records
  end
end
