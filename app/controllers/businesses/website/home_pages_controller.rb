class Businesses::Website::HomePagesController < Businesses::Website::BaseController
  include GroupsAttributesConcern
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  layout 'application'

  before_action do
    @home_page = @website.home_page || @website.build_home_page(active: true)
  end

  def update
    update_resource @home_page, home_page_params, location: [:edit, @business, :website_home_page]
  end

  private

  def home_page_params
    params.require(:home_page).permit(
      :title,
      :sidebar_position,
      groups_attributes: groups_attributes
    ).tap do |safe_params|
      merge_group_blocks_required_placement_attributes(safe_params[:groups_attributes])
    end
  end
end
