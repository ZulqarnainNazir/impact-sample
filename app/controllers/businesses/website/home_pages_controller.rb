class Businesses::Website::HomePagesController < Businesses::Website::BaseController
  include GroupsAttributesConcern
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  layout 'webpage_designer'

  before_action do
    @home_page = @website.home_page || @website.build_home_page(active: true)
  end

  def update
    update_resource @home_page, home_page_params, location: [:edit, @business, :website_home_page]
  end

  private

  def home_page_params
    params.require(:home_page).permit(
      :description,
      :sidebar_position,
      :title,
      groups_attributes: groups_attributes,
      main_image_placement_attributes: placement_attributes,
    ).deep_merge(
      main_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    ).tap do |safe_params|
      merge_group_blocks_required_placement_attributes(safe_params[:groups_attributes])
    end
  end
end
