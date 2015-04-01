class Businesses::ImagesController < Businesses::BaseController
  def index
    @images = Image.
      where('business_id = ? OR user_id = ?', @business.id, current_user.id).
      order('created_at DESC')
  end
end
