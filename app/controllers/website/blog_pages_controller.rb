class Website::BlogPagesController < Website::BaseController
  before_action do
    @page = @website.blog_page or raise ActiveRecord::RecordNotFound
    # get_content_types("BlogFeedGroup", @page)
  end
end
