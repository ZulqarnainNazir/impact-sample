class Businesses::Content::ImagesController < Businesses::Content::BaseController
  before_action only: member_actions do
    @image = image_scope.includes(:placements).find_by_id!(params[:id])
  end

  before_action only: :destroy do
    if @image.placements.any?
      redirect_to [:edit, @business, :content, @image], alert: 'Cannot delete images with attached placements.'
    end
  end

  def index
    @images = image_scope.order(created_at: :desc).page(params[:page]).per(48)
  end

  def update
    update_resource @image, image_params, location: [:edit, @business, :content, @image]
  end

  def destroy
    destroy_resource @image, location: [@business, :content_images]
  end

  private

  def image_scope
    Image.where('business_id = ? OR user_id = ?', @business.id, current_user.id)
  end

  def image_params
    params.require(:image).permit(
      :alt,
      :title,
    )
  end
end
