class Onboard::Website::ThemesController < Onboard::Website::BaseController
  include BlockAttributesConcern

  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])
  end

  before_action do
    if @business.free?
      redirect_to [@business, :dashboard], alert: 'Please upgrade your listing to add a website.'
    end
  end

  before_action do
    unless @business.location && @business.website
      redirect_to [@business, :dashboard], alert: 'No Location or Website Found'
    end
  end

  def edit
  end

  def update
    update_resource @business.website, theme_params, location: [@business, :dashboard]
  end

  private

  def theme_params
    params.require(:website).permit(
      :background_color,
      :foreground_color,
      :link_color,
      :wrap_container,
      :footer_embed,
      :hide_embed_on_landing,
      :hide_embed_on_blog,
      header_block_attributes: block_attributes.push(*%i[logo_height logo_horizontal_position logo_vertical_position logo_bar_fixed navigation_horizontal_position social_enabled contact_position navbar_location]),
      footer_block_attributes: block_attributes.push(FooterBlock::SETTINGS),
    )
  end
end
