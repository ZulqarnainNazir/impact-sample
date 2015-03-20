class Businesses::Website::ThemesController < Businesses::Website::BaseController
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
