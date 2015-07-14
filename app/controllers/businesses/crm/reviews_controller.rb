class Businesses::Crm::ReviewsController < Businesses::BaseController
  before_action only: member_actions do
    @review = @business.reviews.find(params[:id])
  end

  def index
    @reviews = @business.reviews.includes(:customer).order(reviews_order).page(params[:page]).per(20)
  end

  private

  def reviews_order
    if %w[reviewed_at serviced_at overall_rating].include?(params[:order_by])
      "#{params[:order_by]} #{reviews_order_dir} NULLS LAST"
    elsif %w[name].include?(params[:order_by])
      "customers.#{params[:order_by]} #{reviews_order_dir} NULLS LAST"
    else
      "updated_at #{reviews_order_dir} NULLS LAST"
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
