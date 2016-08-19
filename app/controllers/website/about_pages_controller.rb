class Website::AboutPagesController < Website::BaseController
  before_action do
    @page = @website.about_page or raise ActiveRecord::RecordNotFound
    @team_members = @business.team_members
	get_content_types("BlogFeedGroup", @page)
  end
end
