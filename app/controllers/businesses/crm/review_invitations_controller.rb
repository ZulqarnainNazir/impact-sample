class Businesses::Crm::ReviewInvitationsController < Businesses::BaseController
  before_action do
    @customer = @business.customers.find(params[:customer_id])
  end

  def create
    CustomerMailer.review_invitation(@customer).deliver_later
    redirect_to [@business, :crm_customers], notice: "An invitation to review your business has been sent to #{@customer.email}"
  end
end
