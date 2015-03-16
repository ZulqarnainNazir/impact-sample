class Website::CustomPagesController < Website::BaseController
  def show
    @page = @website.pages.custom.find_by_pathname!(params[:id])

    if !@page.active? && @business.owners.include?(current_user)
      raise ActiveRecord::RecordNotFound
    end
  end
end
