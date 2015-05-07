class Businesses::Website::SidebarsController < Businesses::Website::BaseController
  def update
    update_resource @website, sidebars_params, location: [:edit, @business, :website_sidebars]
  end

  private

  def sidebars_params
    params.require(:website).permit(
      :content_blog_sidebar,
    )
  end
end