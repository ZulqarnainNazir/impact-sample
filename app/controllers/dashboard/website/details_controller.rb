class Dashboard::Website::DetailsController < Dashboard::Website::BaseController
  def update
    update_resource @website, website_params, location: @business
  end

  private

  def website_params
    params.require(:website).permit(
      :subdomain,
    )
  end
end
