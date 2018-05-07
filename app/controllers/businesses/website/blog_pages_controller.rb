class Businesses::Website::BlogPagesController < Businesses::Website::BaseController
  include GroupsAttributesConcern
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  layout 'business_webpage_designer_minimal'

  before_action do
    @blog_page = @website.blog_page || @website.build_blog_page(active: true)
  end

  def update
    update_resource @blog_page, blog_page_params, location: [:edit, @business, :website_blog_page]
  end

  private

  def blog_page_params
    params.require(:blog_page).permit(
      :description,
      :page_head_injection,
      :title,
      :sidebar_position,
      groups_attributes: groups_attributes,
      main_image_placement_attributes: placement_attributes,
    ).deep_merge(
      pathname: 'blog',
      name: 'Blog',
      main_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    ).tap do |safe_params|
      merge_group_blocks_required_placement_attributes(safe_params[:groups_attributes])
    end
  end
end
