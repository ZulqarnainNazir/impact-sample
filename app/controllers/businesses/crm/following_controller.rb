class Businesses::Crm::FollowingController < Businesses::BaseController
  def index
    scope = @business.listed_by_business

    @listings = scope.order(companies_order)
  end

  private

  def companies_order
    if %w[name email phone_number].include?(params[:order_by])
      "#{params[:order_by]} #{companies_order_dir} NULLS LAST"
    else
      'CASE WHEN cardinality(read_by) = 0 THEN 0 ELSE 1 END ASC, updated_at DESC'
    end
  end
end
