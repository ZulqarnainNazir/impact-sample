class Dashboard::Website::CustomPagesController < Dashboard::Website::BaseController
  layout 'application'

  before_action only: new_actions do
    @custom_page = CustomPage.new
    @custom_page.website = @website
  end

  before_action only: member_actions do
    @custom_page = @website.pages.custom.find(params[:id])
  end

  def create
    create_resource @custom_page, custom_page_params, location: [@business, :website_pages]
  end

  def update
    update_resource @custom_page, custom_page_params, location: [@business, :website_pages]
  end

  private

  def custom_page_params
    params.require(:custom_page).permit(
      :name,
      :pathname,
      :title,
      :hero_visible,
      :hero_theme,
      :hero_title,
      :hero_text,
      :hero_button,
      :tagline_visible,
      :tagline_theme,
      :tagline_text,
      :tagline_button,
      hero_background_placement_attributes: [
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
      hero_background_placement_attributes: {
        image_attributes: {
          user: current_user,
          business: @business,
        },
      },
    )
  end
end
