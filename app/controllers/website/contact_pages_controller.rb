class Website::ContactPagesController < Website::BaseController
  def show
    @page = @website.contact_page

    if !@page
      raise ActiveRecord::RecordNotFound
    elsif !@page.active? && @business.owners.include?(current_user)
      raise ActiveRecord::RecordNotFound
    end
  end
end
