class Businesses::Website::AboutPagesController < Businesses::Website::BaseController
  include BlockAttributesConcern
  include PlacementAttributesConcern

  layout 'application'

  before_action do
    @about_page = @website.about_page || @website.build_about_page(active: true)
  end

  def update
    update_resource @about_page, about_page_params, location: [:edit, @business, :website_about_page]
  end

  private

  def about_page_params
    params.require(:about_page).permit(
      :title,
      about_block_attributes: block_attributes.push(about_block_image_placement_attributes: placement_attributes),
      team_block_attributes: block_attributes,
    ).deep_merge(
      pathname: 'about',
      name: 'About',
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params[:about_block_attribues], :about_block_image_placement_attributes
    end
  end
end
