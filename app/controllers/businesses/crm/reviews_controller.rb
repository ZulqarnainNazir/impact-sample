class Businesses::Crm::ReviewsController < Businesses::BaseController
  before_action only: member_actions do
    @review = @business.reviews.find(params[:id])
    @review.update_column :read_by, @review.read_by + [current_user.id] unless @review.read_by.include?(current_user.id)
  end

  def index
    @reviews = @business.reviews.includes(:contact).where(hide: false).order(reviews_order) #.page(params[:page]).per(20)
  end

  def destroy
    toggle_resource_boolean_on @review, :hide, location: [@business, :crm_reviews]
  end

  private

  def reviews_order
    if %w[reviewed_at serviced_at overall_rating].include?(params[:order_by])
      "#{params[:order_by]} #{reviews_order_dir} NULLS LAST"
    elsif %w[name].include?(params[:order_by])
      "contacts.#{params[:order_by]} #{reviews_order_dir} NULLS LAST"
    else
      'CASE WHEN cardinality(read_by) = 0 THEN 0 ELSE 1 END ASC, updated_at DESC'
    end
  end

  def reviews_order_dir
    if %w[asc desc].include?(params[:order_dir])
      params[:order_dir]
    else
      'desc'
    end
  end
end
