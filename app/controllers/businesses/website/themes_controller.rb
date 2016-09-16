class Businesses::Website::ThemesController < Businesses::Website::BaseController
  include BlockAttributesConcern
  include RequiresWebPlanConcern

  layout 'application'

  def update
    update_resource @website, website_params, location: [:edit, @business, :website_theme]
    binding.pry
  end

  private

  def website_params
    params.require(:website).permit(
      :custom_css,
      :background_color,
      :foreground_color,
      :link_color,
      :footer_embed,
      :hide_embed_on_blog,
      :hide_embed_on_landing,
      :wrap_container,
      header_block_attributes: block_attributes.push(*%i[logo_height logo_horizontal_position logo_vertical_position navigation_horizontal_position contact_position navbar_location]),
      footer_block_attributes: block_attributes,
    )
  end
end
