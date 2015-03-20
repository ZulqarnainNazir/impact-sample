class Businesses::Website::PublicationsController < Businesses::Website::BaseController
  before_action do
    @page = @website.pages.find(params[:page_id])
  end

  def create
    toggle_resource_boolean_on @page, :active, location: [@business, :website_pages]
  end

  def destroy
    toggle_resource_boolean_off @page, :active, location: [@business, :website_pages]
  end
end
