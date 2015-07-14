class Businesses::Crm::FeedbacksController < Businesses::BaseController
  before_action only: new_actions do
    @customer = @business.customers.find(params[:customer_id])
    @feedback = @customer.feedbacks.new(business: @business)
  end

  before_action only: member_actions do
    @feedback = @business.feedbacks.find(params[:id])
  end

  def index
    @feedbacks = @business.feedbacks.includes(:customer, :review).order(feedbacks_order).page(params[:page]).per(20)
  end

  def create
    create_resource @feedback, feedback_params, location: [@business, :crm_customers]
  end

  private

  def feedback_params
    params.require(:feedback).permit(
      :serviced_at,
    )
  end

  def feedbacks_order
    if %w[serviced_at score].include?(params[:order_by])
      "#{params[:order_by]} #{feedbacks_order_dir} NULLS LAST"
    elsif %w[name].include?(params[:order_by])
      "customers.#{params[:order_by]} #{feedbacks_order_dir} NULLS LAST"
    else
      "updated_at #{feedbacks_order_dir} NULLS LAST"
    end
  end

  def feedbacks_order_dir
    if %w[asc desc].include?(params[:order_dir])
      params[:order_dir]
    else
      'desc'
    end
  end
end
