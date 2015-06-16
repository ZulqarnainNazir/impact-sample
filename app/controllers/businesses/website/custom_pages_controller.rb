class Businesses::Website::CustomPagesController < Businesses::Website::BaseController
  include GroupsAttributesConcern
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  layout 'webpage_designer'

  before_action only: new_actions do
    @custom_page = @website.webpages.new(active: true, type: 'CustomPage')
  end

  before_action only: member_actions do
    @custom_page = @website.webpages.custom.find(params[:id])
    @original_pathname = @custom_page.pathname
  end

  def create
    create_resource @custom_page, custom_page_params, location: [:edit, @business, :website, @custom_page]
  end

  def update
    update_resource @custom_page, custom_page_params, location: [:edit, @business, :website, @custom_page] do |success|
      if success && @custom_page.pathname != @original_pathname
        @website.redirects.create(from_path: @original_pathname, to_path: @custom_page.pathname)
      end
    end
  end

  private

  def custom_page_params
    params.require(:custom_page).permit(
      :title,
      :pathname,
      :name,
      :sidebar_position,
      groups_attributes: groups_attributes
    )
  end
end
