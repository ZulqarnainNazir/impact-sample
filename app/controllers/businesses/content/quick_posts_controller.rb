class Businesses::Content::QuickPostsController < Businesses::Content::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions do
    @quick_post = @business.quick_posts.new
  end

  before_action only: member_actions do
    @quick_post = @business.quick_posts.find(params[:id])
  end

  def create
    create_resource @quick_post, quick_post_params, location: [@business, :content_feed]
  end

  def update
    update_resource @quick_post, quick_post_params, location: [@business, :content_feed]
  end

  def destroy
    destroy_resource @quick_post, location: [@business, :content_feed]
  end

  private

  def quick_post_params
    params.require(:quick_post).permit(
      :title,
      :content,
      quick_post_image_placement_attributes: placement_attributes,
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params, :quick_post_image_placement_attributes
    end
  end
end
