class Dashboard::Website::ContactPagesController < Dashboard::Website::BaseController
  layout 'application'

  before_action do
    @contact_page = @website.contact_page || @website.build_contact_page
  end

  def update
    if params[:publish]
      update_resource @contact_page, contact_page_params.merge(active: true, pathname: '/contact'), location: [@business, :website_pages]
    else
      update_resource @contact_page, contact_page_params.merge(pathname: '/contact'), location: [@business, :website_pages]
    end
  end

  def destroy
    toggle_resource_boolean_off @contact_page, :active, location: [@business, :website_pages]
  end

  private

  def contact_page_params
    params.require(:contact_page).permit(
      :title,
    )
  end
end
