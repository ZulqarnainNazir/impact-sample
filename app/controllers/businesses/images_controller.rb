class Businesses::ImagesController < Businesses::BaseController
  def index
    @images = Image.
      includes(:placements).
      send(*where_clause).
      order(created_at: :desc).
      page(params[:page]).
      per(24)
  end

  private

  def where_clause
    if params[:local] == 'true'
      [:where, ['business_id = ?', @business.id]]
    elsif current_user.super_user?
      [:all]
    else
      [:where, ['business_id = ? OR user_id = ?', @business.id, current_user.id]]
    end
  end
end
