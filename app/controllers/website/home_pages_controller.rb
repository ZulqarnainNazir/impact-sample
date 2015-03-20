class Website::HomePagesController < Website::BaseController
  before_action do
    @page = @website.home_page

    if !@page
      raise ActiveRecord::RecordNotFound
    elsif !@page.active? && !@business.owners.include?(current_user) && false
      raise ActiveRecord::RecordNotFound
    end
  end
end
