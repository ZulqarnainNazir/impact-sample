class Businesses::Website::ThemesController < Businesses::Website::BaseController
  include BlockAttributesConcern
  include RequiresWebPlanConcern

  layout 'business_webpage_designer'

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
      :footer_embed,
      :hide_embed_on_blog,
      :hide_embed_on_landing,
      :header_embed,
      :hide_header_embed_on_blog,
      :hide_header_embed_on_landing,
      :wrap_container,
      component_attributes,
      header_block_attributes: block_attributes.push(*%i[logo_height logo_horizontal_position logo_vertical_position logo_bar_fixed navigation_horizontal_position social_enabled contact_position navbar_location]),
      footer_block_attributes: block_attributes.push(FooterBlock::SETTINGS),
    )
  end

  def component_attributes
    [
      :h1_font_family,
      :h2_font_family,
      :h3_font_family,
      :h4_font_family,
      :h5_font_family,
      :h6_font_family,
      :paragraph_font_family,
      :blockquote_font_family,
      :lead_font_family,
      :h1_font_color,
      :h2_font_color,
      :h3_font_color,
      :h4_font_color,
      :h5_font_color,
      :h6_font_color,
      :paragraph_font_color,
      :blockquote_font_color,
      :lead_font_color,
      :h1_font_desk_size,
      :h2_font_desk_size,
      :h3_font_desk_size,
      :h4_font_desk_size,
      :h5_font_desk_size,
      :h6_font_desk_size,
      :paragraph_font_desk_size,
      :blockquote_font_desk_size,
      :lead_font_desk_size,
      :h1_font_mobile_size,
      :h2_font_mobile_size,
      :h3_font_mobile_size,
      :h4_font_mobile_size,
      :h5_font_mobile_size,
      :h6_font_mobile_size,
      :paragraph_font_mobile_size,
      :blockquote_font_mobile_size,
      :lead_font_mobile_size
    ]
  end
end
