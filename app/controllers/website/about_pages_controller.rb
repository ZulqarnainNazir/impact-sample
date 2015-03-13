class Website::AboutPagesController < Website::BaseController
  def show
    @page = @website.about_page

    if !@page
      raise ActiveRecord::RecordNotFound
    elsif !@page.active? && @business.owners.include?(current_user)
      raise ActiveRecord::RecordNotFound
    end
  end
end
