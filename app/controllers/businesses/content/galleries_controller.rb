class Businesses::Content::GalleriesController < Businesses::Content::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions do
    @gallery = @business.galleries.new
  end

  before_action only: member_actions do
    @gallery = @business.galleries.find(params[:id])
  end

  def create
    create_resource @gallery, gallery_params, location: [@business, :content_feed]
  end

  def update
    update_resource @gallery, gallery_params, location: [@business, :content_feed]
  end

  def destroy
    destroy_resource @gallery, location: [@business, :content_feed]
  end

  private

  def gallery_params
    params.require(:gallery).permit(
      :title,
      :description,
      gallery_images_attributes: [
        :id,
        :_destroy,
        gallery_image_placement_attributes: placement_attributes,
      ],
    ).tap do |safe_params|
      merge_placement_image_attributes_array safe_params[:gallery_images_attributes], :gallery_image_placement_attributes
      if safe_params[:gallery_images_attributes]
        safe_params[:gallery_images_attributes].each do |_, attr|
          attr.merge! gallery: @gallery
        end
      end
    end
  end
end
