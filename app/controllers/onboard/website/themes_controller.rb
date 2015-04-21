class Onboard::Website::ThemesController < Onboard::Website::BaseController
  include BlockAttributesConcern

  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])

    unless @business.location && @business.website
      redirect_to [@business, :dashboard], alert: 'No Location or Website Found'
    end
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
      header_block_attributes: block_attributes,
      footer_block_attributes: block_attributes,
    )
  end
end
