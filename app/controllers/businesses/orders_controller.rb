class Businesses::OrdersController < Businesses::BaseController
  def index
    @orders = @business.orders.all
  end

  def show
    @order = @business.order.find(params[:id])
  end

  # def new
  #   @order = @business.order.new
  # end

  def create
    @order = @business.order.new(order_params)

    @current_cart.line_items.each do |item|
      @order.line_items << item
      item.cart_id = nil
    end

    @order.save

    # Cart.destroy(session[:cart_id])
    # session[:cart_id] = nil

    redirect_to root_path
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
