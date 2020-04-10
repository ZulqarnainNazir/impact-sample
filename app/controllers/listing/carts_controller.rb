# require 'search_helper'
class Listing::CartsController < Listing::BaseController
  layout "listing"

  def index
    @business = Business.listing_lookup(params[:lookup])
    @products = @business.products
  end

  def new
    # Creates stripe session, pending order and redirects to Checkout

    business = Business.listing_lookup(params[:lookup])
    cart = Cart.find(session[:cart_id])
    items = cart.line_items.joins(:product).where(products: {business_id: business.id})
    shipping_required = items.where(products: {delivery_type: 3}).present?

    stripe = StripeService.new(request)
    session = stripe.create_checkout_session(business, items, shipping_required, "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/cart/show?session_id={CHECKOUT_SESSION_ID}", "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/cart")

    Order.create!(business_id: business.id, stripe_checkout_session_id: session.id, cart_id: cart.id, total_amount: cart.cart_total(business))

    render json: { session_id: session.id }

  end

  def show
    # Thank you page
    @business = Business.listing_lookup(params[:lookup])
    @order = Order.find_by(stripe_checkout_session_id: params[:session_id])
    @products = @business.products

    unless @order.present? && !@order.pending?
      flash[:notice] = "Looking for your order? The session may have expired. Please check your email for your order confirmation. If you did not receive one please contact support."
      redirect_to "https://#{ENV['LISTING_HOST']}#{@business.generate_listing_path}/products"
    end
  end
end
