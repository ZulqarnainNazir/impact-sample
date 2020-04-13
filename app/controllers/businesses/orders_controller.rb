class Businesses::OrdersController < Businesses::BaseController
  def index
    @orders = @business.orders.where.not(status: 0).order('created_at desc')
  end

  def show
    @order = Order.find(params[:id])
  end

  # def new
  #   @order = @business.order.new
  # end

  def create
    @order = @business.order.create(order_params)
  end

  def update

    @order = Order.find(params[:id])

    if @order.update_attributes(status: 'delivered')

      #Send fullfilment email confirmation
      OrdersMailer.order_fulfillment_confirmation(order).deliver_later

      render json: { text: 'Ok' }
    else
      render text: 'Error', status: 422
    end

  end

  private

  def order_params
    params.require(:order).permit(
      :first_name,
      :last_name,
      :email,
      :shipping_address,
      :order_date,
      :total_amount,
      :stripe_checkout_session_id,
      :stripe_customer_id,
     )
  end

end
