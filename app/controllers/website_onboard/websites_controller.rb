class WebsiteOnboard::WebsitesController < WebsiteOnboard::BaseController
  before_action do
    @business = current_user.businesses.find(params[:business_id])
  end

  before_action do
    if !@business.location
      redirect_to [:edit_website_onboard, @business, :location]
    end
  end

  before_action do
    @website = @business.website || @business.build_website
  end

  def update
    update_resource @website, website_params, location: [:edit_website_onboard, @business, :home_page]
  end

  private

  def website_params
    params.require(:website).permit(
      :subdomain,
      :header,
      :header_style,
      :footer,
    )
  end
end
