class Website::BlogPagesController < Website::BaseController
  before_action do
    @page = @website.blog_page or raise ActiveRecord::RecordNotFound
    @content_types = @page.groups.where(type:"BlogFeedGroup").first.blocks.first.content_types.split
    @masonry = true
    if !params[:content_types].present?
    	params[:content_types] = @content_types
    end
  end
end
