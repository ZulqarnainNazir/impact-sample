class Website::CustomPagesController < Website::BaseController
  before_action do
    @page = @website.webpages.custom.find_by_pathname!(params[:id])
	  get_content_types("BlogFeedGroup", @page)
  end
end
