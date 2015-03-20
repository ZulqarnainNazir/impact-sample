class Onboard::Website::WebsitesController < Onboard::Website::BaseController
  before_action do
    @business = current_user.businesses.find(params[:business_id])
  end

  before_action do
    if !@business.location
      redirect_to [:edit_onboard_website, @business, :location]
    end
  end

  before_action do
    @website = @business.website || @business.build_website
  end

  def update
    update_resource @website, website_params, location: [:edit_onboard_website, @business, :pages]
  end

  private

  def website_params
    params.require(:website).permit(
      :subdomain,
      :header,
      :header_style,
      :footer,
      logo_placement_attributes: [
        :id,
        :_destroy,
        image_attributes: [
          :id,
          :alt,
          :title,
          :attachment_cache_url,
          :attachment_content_type,
          :attachment_file_name,
          :attachment_file_size,
          :_destroy,
        ],
      ],
    ).deep_merge(
      logo_placement_attributes: {
        image_attributes: {
          user: current_user,
          business: @business,
        },
      },
    )
  end
end
