class Dashboard::Website::ThemesController < Dashboard::Website::BaseController
  layout 'application'

  def update
    update_resource @website, website_params, location: [:edit, @business, :website_theme]
  end

  private

  def website_params
    params.require(:website).permit(
      :custom_css,
      :header,
      :header_style,
      :footer,
    )
  end
end
