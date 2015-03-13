class Dashboard::Website::AboutPagesController < Dashboard::Website::BaseController
  layout 'application'

  before_action do
    @about_page = @website.about_page || @website.build_about_page
  end

  def update
    if params[:publish]
      update_resource @about_page, about_page_params.merge(active: true, pathname: '/about'), location: [@business, :website_pages]
    else
      update_resource @about_page, about_page_params.merge(pathname: '/about'), location: [@business, :website_pages]
    end
  end

  def destroy
    toggle_resource_boolean_off @about_page, :active, location: [@business, :website_pages]
  end

  private

  def about_page_params
    params.require(:about_page).permit(
      :title,
    )
  end
end
