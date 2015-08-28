class Businesses::Website::WebpagesController < Businesses::Website::BaseController
  include RequiresWebPlanConcern

  layout 'application'

  before_action only: member_actions do
    @webpage = @website.webpages.find(params[:id])
  end

  def index
    @home_page = @website.home_page
    @about_page = @website.about_page
    @contact_page = @website.contact_page
    @custom_pages = @website.webpages.custom
  end

  def table
    @webpages = @website.webpages.order(active: :asc, pathname: :asc)
  end

  def destroy
    destroy_resource @webpage, location: [@business, :website_webpages]
  end
end
