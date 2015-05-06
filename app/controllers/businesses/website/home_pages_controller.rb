class Businesses::Website::HomePagesController < Businesses::Website::BaseController
  include BlockAttributesConcern
  include PlacementAttributesConcern

  layout 'application'

  before_action do
    @home_page = @website.home_page || @website.build_home_page(active: true)
  end

  def update
    update_resource @home_page, home_page_params, location: [:edit, @business, :website_home_page]
  end

  private

  def home_page_params
    params.require(:home_page).permit(
      :title,
      :block_type_order,
      :call_to_action_blocks_per_row,
      hero_block_attributes: block_attributes.push(hero_block_image_placement_attributes: placement_attributes),
      specialty_blocks_attributes: block_attributes.push(specialty_block_image_placement_attributes: placement_attributes),
      tagline_blocks_attributes: block_attributes,
      call_to_action_blocks_attributes: block_attributes.push(call_to_action_block_image_placement_attributes: placement_attributes),
      content_blocks_attributes: block_attributes.push(content_block_image_placement_attributes: placement_attributes),
      feed_block_attributes: block_attributes.push(:items_limit, :width),
    ).deep_merge(
      pathname: '',
      name: 'Homepage',
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params[:hero_block_attributes], :hero_block_image_placement_attributes
      merge_placement_image_attributes_array safe_params[:specialty_blocks_attributes], :specialty_block_image_placement_attributes
      merge_placement_image_attributes_array safe_params[:call_to_action_blocks_attributes], :call_to_action_block_image_placement_attributes
      merge_placement_image_attributes_array safe_params[:content_blocks_attributes], :content_block_image_placement_attributes
    end
  end
end
