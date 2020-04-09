class Businesses::OrdersController < Businesses::BaseController
  def index
    @orders = @business.orders.where.not(status: 0).order('created_at desc')
  end

  def show
    @order = @business.order.find(params[:id])
  end

  # def new
  #   @order = @business.order.new
  # end

  def create
    @order = @business.order.create(order_params)
    # @order.save
    # redirect_to root_path
  end

  private

  def order_params
    params.require(:order).permit(
      :first_name,
      :last_name,
      :email,
      :shipping_address,
      :total_amount,
      :stripe_checkout_session_id,
      :stripe_customer_id,
     )
  end

end
