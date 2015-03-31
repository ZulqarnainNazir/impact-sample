class Businesses::Website::WebpagesController < Businesses::Website::BaseController
  layout 'application'

  def index
    @home_page = @website.home_page
    @about_page = @website.about_page
    @contact_page = @website.contact_page
    @custom_pages = @website.webpages.custom
  end
end
