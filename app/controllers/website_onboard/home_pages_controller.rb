class WebsiteOnboard::HomePagesController < WebsiteOnboard::BaseController
  before_action do
    @business = current_user.businesses.find(params[:business_id])
  end

  before_action do
    if !@business.location
      redirect_to [:edit_website_onboard, @business, :location]
    elsif !@business.website
      redirect_to [:edit_website_onboard, @business, :website]
    end
  end

  before_action do
    @home_page = @business.website.home_page || @business.website.build_home_page
  end

  def update
    update_resource @home_page, home_page_params.merge(pathname: ''), location: @business
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
