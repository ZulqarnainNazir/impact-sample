class Dashboard::Website::AboutPagesController < Dashboard::Website::BaseController
  layout 'application'

  before_action do
    @about_page = @website.about_page || @website.build_about_page
  end

  def update
    if params[:publish]
      update_resource @about_page, about_page_params.merge(active: true, pathname: 'about'), location: [@business, :website_pages]
    else
      update_resource @about_page, about_page_params.merge(pathname: 'about'), location: [@business, :website_pages]
    end
  end

  def destroy
    toggle_resource_boolean_off @about_page, :active, location: [@business, :website_pages]
  end

  private

  def about_page_params
    params.require(:about_page).permit(
      :title,
      :about_visible,
      :about_theme,
      :about_heading,
      :about_subheading,
      :about_text,
      :team_visible,
      :team_theme,
      about_background_placement_attributes: [
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
      about_background_placement_attributes: {
        image_attributes: {
          user: current_user,
          business: @business,
        },
      },
    )
  end
end
