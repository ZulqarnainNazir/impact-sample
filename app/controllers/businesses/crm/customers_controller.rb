class Businesses::Crm::CustomersController < Businesses::BaseController
  before_action only: new_actions do
    @customer = @business.customers.new
  end

  before_action only: member_actions do
    @customer = @business.customers.find(params[:id])
    @customer.update_column :read_by, @customer.read_by + [current_user.id] unless @customer.read_by.include?(current_user.id)
  end

  def index
    @customers = @business.customers.includes(:feedback).where(hide: false).order(customers_order).page(params[:page]).per(20)
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

  def destroy
    toggle_resource_boolean_on @customer, :hide, location: [@business, :crm_customers]
  end

  private

  def customer_params
    params.require(:customer).permit(
      :name,
      :email,
      :phone,
      customer_notes_attributes: [
        :content,
      ],
      feedbacks_attributes: [
        :serviced_at,
        :_destroy,
      ],
    ).tap do |safe_params|
      if safe_params[:customer_notes_attributes]
        safe_params[:customer_notes_attributes].map do |_, attr|
          attr[:user_name] = current_user.name if attr[:content].present?
        end
      end
      if safe_params[:feedbacks_attributes]
        safe_params[:feedbacks_attributes].map do |_, attr|
          attr[:business] = @business
          attr[:_destroy] = '1' if params[:_inverse_destroy] != '1'
        end
      end
    end
  end

  def customers_order
    if %w[name email phone].include?(params[:order_by])
      "#{params[:order_by]} #{customers_order_dir} NULLS LAST"
    elsif %w[serviced_at completed_at score].include?(params[:order_by])
      "feedbacks.#{params[:order_by]} #{customers_order_dir} NULLS LAST"
    else
      'CASE WHEN cardinality(read_by) = 0 THEN 0 ELSE 1 END ASC, updated_at DESC'
    end
  end

  def customers_order_dir
    if %w[asc desc].include?(params[:order_dir])
      params[:order_dir]
    else
      'desc'
    end
  end
end
