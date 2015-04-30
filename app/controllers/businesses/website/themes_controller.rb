class Businesses::Website::ThemesController < Businesses::Website::BaseController
  include BlockAttributesConcern

  layout 'application'

  def update
    update_resource @website, website_params, location: [:edit, @business, :website_theme]
  end

  private

  def website_params
    params.require(:website).permit(
      :custom_css,
      :background_color,
      :foreground_color,
      :link_color,
      header_block_attributes: block_attributes.push(:logo_height),
      footer_block_attributes: block_attributes,
    )
  end
end
