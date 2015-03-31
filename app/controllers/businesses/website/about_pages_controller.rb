class Businesses::Website::AboutPagesController < Businesses::Website::BaseController
  layout 'application'

  before_action do
    @about_page = @website.about_page || @website.build_about_page
  end

  def update
    update_resource @about_page, about_page_params, location: [:edit, @business, :website_about_page]
  end

  private

  def about_page_params
    basic_about_page_params.tap do |page_params|
      if page_params[:about_block_attributes]
        page_params[:about_block_attributes].merge! image_business: @business, image_user: current_user
      end
    end
  end

  def basic_about_page_params
    params.require(:about_page).permit(
      :title,
      about_block_attributes: block_attributes,
      team_block_attributes: block_attributes,
    ).deep_merge(
      pathname: 'about',
      name: 'About',
    )
  end
end
