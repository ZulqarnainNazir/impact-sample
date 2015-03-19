class Dashboard::Website::HomePagesController < Dashboard::Website::BaseController
  layout 'application'

  before_action do
    @home_page = @website.home_page || @website.build_home_page
  end

  def update
    update_resource @home_page, home_page_params.merge(pathname: ''), location: [:edit, @business, :website_home_page]
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
      :cta_visible,
      :cta_theme,
      :cta_title_01,
      :cta_text_01,
      :cta_button_01,
      :cta_title_02,
      :cta_text_02,
      :cta_button_02,
      :cta_title_03,
      :cta_text_03,
      :cta_button_03,
      :specialty_visible,
      :specialty_theme,
      :specialty_heading,
      :specialty_subheading,
      :specialty_text,
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
      cta_background_01_placement_attributes: [
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
      cta_background_02_placement_attributes: [
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
      cta_background_03_placement_attributes: [
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
      specialty_background_placement_attributes: [
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
      cta_background_01_placement_attributes: {
        image_attributes: {
          user: current_user,
          business: @business,
        },
      },
      cta_background_02_placement_attributes: {
        image_attributes: {
          user: current_user,
          business: @business,
        },
      },
      cta_background_03_placement_attributes: {
        image_attributes: {
          user: current_user,
          business: @business,
        },
      },
      specialty_background_placement_attributes: {
        image_attributes: {
          user: current_user,
          business: @business,
        },
      },
    )
  end
end
