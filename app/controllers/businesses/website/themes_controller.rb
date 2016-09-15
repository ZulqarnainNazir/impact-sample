class Businesses::Website::ThemesController < Businesses::Website::BaseController
  include BlockAttributesConcern
  include RequiresWebPlanConcern

  layout 'application'

  def update
    binding.pry
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
<<<<<<< 65fafb1107bcea5f6c4686d912853935a7da8605
      :embed_on_blog,
      :embed_on_landing,
=======
>>>>>>> basic text form for footer embed: need to finish by adding it to the layout and restricting where it appears
      :wrap_container,
      header_block_attributes: block_attributes.push(*%i[logo_height logo_horizontal_position logo_vertical_position navigation_horizontal_position contact_position navbar_location]),
      footer_block_attributes: block_attributes,
    )
  end
end
