class Businesses::Crm::CustomersController < Businesses::BaseController
  before_action only: new_actions do
    @customer = @business.customers.new
  end

  before_action only: member_actions do
    @customer = @business.customers.find(params[:id])
  end

  def index
    @customers = @business.customers.page(params[:page]).per(20)
  end

  def create
    create_resource @customer, customer_params, location: [@business, :crm_customers] do |success|
      if success && params[:review_invitation]
        CustomerMailer.review_invitation(@customer).deliver_later
      end
    end
  end

  def update
    update_resource @customer, customer_params, location: [@business, :crm_customers]
  end

  private

  def customer_params
    params.require(:customer).permit(
      :name,
      :email,
      :phone,
      :notes,
      feedbacks_attributes: [
        :serviced_at,
        :_destroy,
      ],
    ).tap do |safe_params|
      if safe_params[:feedbacks_attributes]
        safe_params[:feedbacks_attributes].map do |_, attr|
          attr[:business] = @business
        end
      end
    end
  end
end
