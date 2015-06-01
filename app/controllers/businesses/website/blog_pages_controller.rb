class Businesses::Website::BlogPagesController < Businesses::Website::BaseController
  include BlockAttributesConcern
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  layout 'application'

  before_action do
    @blog_page = @website.blog_page || @website.build_blog_page(active: true)
  end

  def update
    update_resource @blog_page, blog_page_params, location: [:edit, @business, :website_blog_page]
  end

  private

  def blog_page_params
    params.require(:blog_page).permit(
      :title,
      :sidebar_position,
      feed_block_attributes: block_attributes.push(:items_limit),
      sidebar_content_blocks_attributes: block_attributes.push(sidebar_content_block_image_placement_attributes: placement_attributes),
    ).deep_merge(
      pathname: 'blog',
      name: 'Blog',
    ).tap do |safe_params|
      merge_placement_image_attributes_array safe_params[:sidebar_content_blocks_attributes], :sidebar_content_block_image_placement_attributes
    end
  end
end
