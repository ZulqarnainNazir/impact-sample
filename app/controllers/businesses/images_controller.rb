class Businesses::ImagesController < Businesses::BaseController
  def index
    @images = Image.
      includes(:placements).
      where('business_id = ? OR user_id = ?', @business.id, current_user.id).
      order(created_at: :desc).
      page(params[:page]).
      per(48)
  end
end
