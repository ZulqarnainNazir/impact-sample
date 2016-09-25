class Businesses::Website::AboutPagesController < Businesses::Website::BaseController
  include GroupsAttributesConcern
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  layout 'webpage_designer'

  before_action do
    @about_page = @website.about_page || @website.build_about_page(active: true)
  end

  def update
    update_resource @about_page, about_page_params, location: [:edit, @business, :website_about_page]
  end

  private

  def about_page_params
    params.require(:about_page).permit(
      :description,
      :page_head_injection,
      :title,
      groups_attributes: groups_attributes,
      main_image_placement_attributes: placement_attributes,
    ).deep_merge(
      pathname: 'about',
      name: 'About',
      main_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    ).tap do |safe_params|
      merge_group_blocks_required_placement_attributes(safe_params[:groups_attributes])
    end
  end
end
