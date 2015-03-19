class Dashboard::Website::ContactPagesController < Dashboard::Website::BaseController
  layout 'application'

  before_action do
    @contact_page = @website.contact_page || @website.build_contact_page
  end

  def update
    update_resource @contact_page, contact_page_params.merge(pathname: 'contact'), location: [:edit, @business, :website_contact_page]
  end

  private

  def contact_page_params
    params.require(:contact_page).permit(
      :title,
      :text,
      :contact_theme,
    )
  end
end
