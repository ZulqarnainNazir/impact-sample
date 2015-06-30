class Businesses::Website::SidebarsController < Businesses::Website::BaseController
  include RequiresWebPlanConcern

  def update
    update_resource @website, sidebars_params, location: [:edit, @business, :website_sidebars]
  end

  private

  def sidebars_params
    params.require(:website).permit(
      :content_blog_sidebar,
      :content_blog_sidebar_on_reviews,
      :events_sidebar,
    )
  end
end
