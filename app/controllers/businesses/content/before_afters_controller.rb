class Businesses::Content::BeforeAftersController < Businesses::Content::BaseController
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  before_action only: new_actions do
    @before_after = @business.before_afters.new
  end

  before_action only: member_actions do
    @before_after = @business.before_afters.find(params[:id])
  end

  def create
    create_resource @before_after, before_after_params, location: [@business, :content_feed] do |success|
      if success
        BeforeAfter.__elasticsearch__.refresh_index!
        intercom_event 'created-before-after'
      end
    end
  end

  def update
    update_resource @before_after, before_after_params, location: [@business, :content_feed] do |success|
      if success
        BeforeAfter.__elasticsearch__.refresh_index!
      end
    end
  end

  def destroy
    destroy_resource @before_after, location: [@business, :content_feed] do |success|
      if success
        BeforeAfter.__elasticsearch__.refresh_index!
      end
    end
  end

  private

  def before_after_params
    params.require(:before_after).permit(
      :description,
      :meta_description,
      :title,
      content_category_ids: [],
      content_tag_ids: [],
      after_image_placement_attributes: placement_attributes,
      before_image_placement_attributes: placement_attributes,
      main_image_placement_attributes: placement_attributes,
    ).deep_merge(
      after_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
      before_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
      main_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    )
  end
end
