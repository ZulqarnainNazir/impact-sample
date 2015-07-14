class Businesses::Crm::FeedbacksController < Businesses::BaseController
  before_action only: new_actions do
    @customer = @business.customers.find(params[:customer_id])
  end

  before_action only: member_actions do
    @feedback = @business.feedbacks.find(params[:id])
    @feedback.update_column :read_by, @feedback.read_by + [current_user.id] unless @feedback.read_by.include?(current_user.id)
  end

  def index
    @feedbacks = @business.feedbacks.includes(:customer, :review).where(hide: false).order(feedbacks_order).page(params[:page]).per(20)
  end

  def create
    create_resource @feedback, feedback_params, location: [@business, :crm_customers]
  end

  def destroy
    toggle_resource_boolean_on @feedback, :hide, location: [@business, :crm_feedbacks]
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
      'CASE WHEN cardinality(read_by) = 0 THEN 0 ELSE 1 END ASC, updated_at DESC'
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
