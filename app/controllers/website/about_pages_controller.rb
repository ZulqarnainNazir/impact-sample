class Website::AboutPagesController < Website::BaseController
  before_action do
    @page = @website.about_page or raise ActiveRecord::RecordNotFound
    @team_members = @business.team_members
  	# get_content_types("BlogFeedGroup", @page)
    params[:content_types] = @page.groups.where(type: 'BlogFeedGroup').first.blocks.first.content_types.split
    # params[:content_types] = ['Event']
    # params[:content_types] = @page.content_types.join(" ").split
    # params[:content_types].present? ? params @content_types_all
    # "QuickPost Gallery BeforeAfter Offer Post Job"
  end

end
