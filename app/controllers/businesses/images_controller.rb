class Businesses::ImagesController < Businesses::BaseController
  def index
    @images = Image.
      includes(:placements).
      where(where_clause).
      order(created_at: :desc).
      page(params[:page]).
      per(48)
  end

  private

  def where_clause
    if params[:local] == 'true'
      ['business_id = ?', @business.id]
    else
      ['business_id = ? OR user_id = ?', @business.id, current_user.id]
    end
  end
end
