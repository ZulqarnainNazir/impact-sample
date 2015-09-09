class Businesses::Content::GalleriesController < Businesses::Content::BaseController
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  before_action only: new_actions do
    @gallery = @business.galleries.new
  end

  before_action only: member_actions do
    @gallery = @business.galleries.find(params[:id])
  end

  def create
    create_resource @gallery, gallery_params, location: [@business, :content_feed] do |success|
      if success
        Gallery.__elasticsearch__.refresh_index!
        intercom_event 'created-gallery'
      end
    end
  end

  def update
    update_resource @gallery, gallery_params, location: [@business, :content_feed] do |success|
      if success
        Gallery.__elasticsearch__.refresh_index!
      end
    end
  end

  def destroy
    destroy_resource @gallery, location: [@business, :content_feed] do |success|
      if success
        Gallery.__elasticsearch__.refresh_index!
      end
    end
  end

  private

  def gallery_params
    params.require(:gallery).permit(
      :description,
      :meta_description,
      :title,
      content_category_ids: [],
      content_tag_ids: [],
      main_image_placement_attributes: placement_attributes,
      gallery_images_attributes: [
        :id,
        :_destroy,
        gallery_image_placement_attributes: placement_attributes,
      ],
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params, :main_image_placement_attributes
      merge_placement_image_attributes_array safe_params[:gallery_images_attributes], :gallery_image_placement_attributes
      if safe_params[:gallery_images_attributes]
        safe_params[:gallery_images_attributes].each do |_, attr|
          attr.merge! gallery: @gallery
        end
      end
    end
  end
end
