class Website::CustomPagesController < Website::BaseController
  before_action do
    @page = @website.webpages.custom.find_by_pathname!(params[:id])

    if !@page.active? && !@business.owners.include?(current_user) && false
      raise ActiveRecord::RecordNotFound
    end
  end
end
