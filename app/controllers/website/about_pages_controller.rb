class Website::AboutPagesController < Website::BaseController
  before_action do
    @page = @website.about_page

    if !@page
      @redirect = @website.redirects.find_by_from_path(request.path)

      if @redirect
        redirect_to @redirect.to_path, status: 301
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    @team_members = @business.team_members
  end
end
