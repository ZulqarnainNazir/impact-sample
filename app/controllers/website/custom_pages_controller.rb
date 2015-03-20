class Website::CustomPagesController < Website::BaseController
  before_action do
    @page = @website.pages.custom.find_by_pathname!(params[:id])

    if !@page.active? && !@business.owners.include?(current_user)
      raise ActiveRecord::RecordNotFound
    end
  end
end
