class Website::BlogPagesController < Website::BaseController
  before_action do
    @page = @website.blog_page or raise ActiveRecord::RecordNotFound
    @content_types_all = @page.groups.where(type:"BlogFeedGroup").first.blocks.first.content_types.split
    @masonry = true
    if !params[:content_types].present?
    	params[:content_types] = @content_types_all
    elsif params[:content_types].present?
    	@content_types = params[:content_types]
    end
  end
end
