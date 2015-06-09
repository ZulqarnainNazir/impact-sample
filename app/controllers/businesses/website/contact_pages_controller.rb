class Businesses::Website::ContactPagesController < Businesses::Website::BaseController
  include GroupsAttributesConcern
  include RequiresWebPlanConcern

  layout 'application'

  before_action do
    @contact_page = @website.contact_page || @website.build_contact_page(active: true)
  end

  def update
    update_resource @contact_page, contact_page_params, location: [:edit, @business, :website_contact_page]
  end

  private

  def contact_page_params
    params.require(:contact_page).permit(
      :title,
      groups_attributes: groups_attributes
    ).deep_merge(
      pathname: 'contact',
      name: 'Contact',
    )
  end
end
