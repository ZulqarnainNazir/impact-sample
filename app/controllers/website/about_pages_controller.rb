class Website::AboutPagesController < Website::BaseController
  before_action do
    @page = @website.about_page

    if !@page
      raise ActiveRecord::RecordNotFound
    elsif !@page.active? && !@business.owners.include?(current_user)
      raise ActiveRecord::RecordNotFound
    else
      @team_members = @business.team_members
    end
  end
end
