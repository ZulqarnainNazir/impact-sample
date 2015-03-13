class Dashboard::Website::HomePagesController < Dashboard::Website::BaseController
  layout 'application'

  before_action do
    @home_page = @website.home_page || @website.build_home_page
  end

  def update
    if params[:publish]
      update_resource @home_page, home_page_params.merge(active: true, pathname: '/'), location: [@business, :website_pages]
    else
      update_resource @home_page, home_page_params.merge(pathname: '/'), location: [@business, :website_pages]
    end
  end

  def destroy
    toggle_resource_boolean_off @home_page, :active, location: [@business, :website_pages]
  end

  private

  def home_page_params
    params.require(:home_page).permit(
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
      :layout_visible,
      :layout_theme,
      :reviews_visible,
      :reviews_theme,
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
