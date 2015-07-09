class Businesses::Crm::FeedbacksController < Businesses::BaseController
  before_action only: new_actions do
    @customer = @business.customers.find(params[:customer_id])
    @feedback = @customer.feedbacks.new(business: @business)
  end

  before_action only: member_actions do
    @feedback = @business.feedbacks.find(params[:id])
  end

  def index
    @feedbacks = @business.feedbacks.page(params[:page]).per(20)
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
end
