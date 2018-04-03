class Businesses::Website::ContactPagesController < Businesses::Website::BaseController
  include GroupsAttributesConcern
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  layout 'business_webpage_designer_minimal'

  before_action do
    @contact_page = @website.contact_page || @website.build_contact_page(active: true)
  end

  def update
    update_resource @contact_page, contact_page_params, location: [:edit, @business, :website_contact_page]
  end

  private

  def contact_page_params
    params.require(:contact_page).permit(
      :description,
      :title,
      :page_head_injection,
      groups_attributes: groups_attributes,
      main_image_placement_attributes: placement_attributes,
    ).deep_merge(
      pathname: 'contact',
      name: 'Contact',
      main_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    )
  end
end
