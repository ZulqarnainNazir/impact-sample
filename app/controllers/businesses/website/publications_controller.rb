class Businesses::Website::PublicationsController < Businesses::Website::BaseController
  before_action do
    @webpage = @website.webpages.find(params[:webpage_id])
  end

  def create
    toggle_resource_boolean_on @webpage, :active, location: [@business, :website_webpages]
  end

  def destroy
    toggle_resource_boolean_off @webpage, :active, location: [@business, :website_webpages]
  end
end
