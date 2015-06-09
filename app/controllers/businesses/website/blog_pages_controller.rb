class Businesses::Website::BlogPagesController < Businesses::Website::BaseController
  include GroupsAttributesConcern
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
      groups_attributes: groups_attributes
    ).deep_merge(
      pathname: 'blog',
      name: 'Blog',
    )
  end
end
