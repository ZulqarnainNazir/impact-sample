class Businesses::Content::ImagesController < Businesses::Content::BaseController
  skip_before_action :confirm_content_activated
  
  before_action only: member_actions do
    @image = Image.where('business_id = ? OR user_id = ?', @business.id, current_user.id).includes(:placements).find_by_id!(params[:id])
  end

  before_action only: :destroy do
    if @image.placements.any?
      redirect_to [:edit, @business, :content, @image], alert: 'Cannot delete images with attached placements.'
    end
  end

  def index
    if current_user.businesses.count > 1 || current_user.super_user?
      params[:local] ||= 'true'
    else
      params[:local] = 'true'
    end

    if params[:local] == 'true'
      @images = Image.where(business_id: @business.id).order(created_at: :desc).page(params[:page]).per(48)
    else
      @images = Image.where('business_id = ? OR user_id = ?', @business.id, current_user.id).order(created_at: :desc).page(params[:page]).per(48)
    end
  end

  def update
    update_resource @image, image_params, location: [:edit, @business, :content, @image]
  end

  def destroy
    destroy_resource @image, location: [@business, :content_images]
  end

  private

  def image_params
    params.require(:image).permit(
      :alt,
      :title,
    )
  end
end
