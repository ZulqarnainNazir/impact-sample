class Dashboard::Website::ThemesController < Dashboard::Website::BaseController
  layout 'application'

  def update
    update_resource @website, website_params, location: @business
  end

  private

  def website_params
    params.require(:website).permit(
      :header,
      :header_style,
      :footer,
    )
  end
end
