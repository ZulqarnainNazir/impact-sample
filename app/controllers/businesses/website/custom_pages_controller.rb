class Businesses::Website::CustomPagesController < Businesses::Website::BaseController
  include GroupsAttributesConcern
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  layout 'business_webpage_designer'

  before_action only: new_actions do
    @custom_page = @website.webpages.new(active: true, type: 'CustomPage')
  end

  before_action only: member_actions do
    @custom_page = @website.webpages.custom.find(params[:id])
    @original_pathname = @custom_page.pathname
  end

  def create
    pathname = params[:custom_page][:pathname]
    if @website.webpages.find_by(pathname: pathname)
      duplicates = 2
      pathname = "#{pathname}-2"
      while @website.webpages.find_by(pathname: pathname)
        duplicates += 1
        pathname[-1] = duplicates.to_s
      end
      params[:custom_page][:pathname] = pathname
    end
    create_resource @custom_page, custom_page_params, location: [:edit, @business, :website, @custom_page] do |success|
      intercom_event 'created-custom-webpage'
    end
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
      :description,
      :title,
      :pathname,
      :page_head_injection,
      :name,
      :sidebar_position,
      :hide_navigation,
      :no_index,
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
