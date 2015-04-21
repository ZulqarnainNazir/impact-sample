class Businesses::Website::CustomPagesController < Businesses::Website::BaseController
  include BlockAttributesConcern
  include PlacementAttributesConcern

  layout 'application'

  before_action only: new_actions do
    @custom_page = @website.webpages.new(type: 'CustomPage')
  end

  before_action only: member_actions do
    @custom_page = @website.webpages.custom.find(params[:id])
  end

  def create
    create_resource @custom_page, custom_page_params, location: [:edit, @business, :website, @custom_page]
  end

  def update
    update_resource @custom_page, custom_page_params, location: [:edit, @business, :website, @custom_page]
  end

  private

  def custom_page_params
    params.require(:custom_page).permit(
      :title,
      :pathname,
      :name,
      :block_type_order,
      :call_to_action_blocks_per_row,
      hero_block_attributes: block_attributes.push(hero_block_image_placement_attributes: placement_attributes),
      specialty_blocks_attributes: block_attributes.push(specialty_block_image_placement_attributes: placement_attributes),
      tagline_blocks_attributes: block_attributes,
      call_to_action_blocks_attributes: block_attributes.push(call_to_action_block_image_placement_attributes: placement_attributes),
      content_blocks_attributes: block_attributes.push(content_block_image_placement_attributes: placement_attributes),
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params[:hero_block_attributes], :hero_block_image_placement_attributes
      merge_placement_image_attributes_array safe_params[:specialty_blocks_attributes], :specialty_block_image_placement_attributes
      merge_placement_image_attributes_array safe_params[:call_to_action_blocks_attributes], :call_to_action_block_image_placement_attributes
      merge_placement_image_attributes_array safe_params[:content_blocks_attributes], :content_block_image_placement_attributes
    end
  end
end
