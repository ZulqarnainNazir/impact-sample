class Website::BlogPagesController < Website::BaseController
  before_action do
    @page = @website.blog_page or raise ActiveRecord::RecordNotFound
    @masonry = true
  end
end
