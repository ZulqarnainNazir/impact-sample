# require 'search_helper'
class Listing::CartsController < Listing::BaseController
  layout "listing"

  def index
    @business = Business.listing_lookup(params[:lookup])
    @products = @business.products
  end

  def new
    business = Business.listing_lookup(params[:lookup])
    cart = Cart.find(session[:cart_id])
    items = cart.line_items.joins(:product).where(products: {business_id: business.id})
    shipping_required = items.where(products: {require_shipping_address: true}).present?

    stripe = StripeService.new(request)
    session = stripe.create_checkout_session(business, items, shipping_required, "http://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/cart/create", "http://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/cart")


    Order.create!(business_id: business.id, stripe_checkout_session_id: session.id)

    render json: { session_id: session.id }

  end

  def create

    business = Business.listing_lookup(params[:lookup])
    cart = Cart.find(session[:cart_id])
    items = cart.line_items.joins(:product).where(products: {business_id: business.id})


    # Record Order
    # Order.new(business, items, status)

    # Empty cart by assigning line items to order and setting cart_id to nil
    # items.update_all(cart_id: nil, order_id: order.id)

    # items.delete_all


    # Redirect to lisitng product path
    flash[:success] = "Thank you for your purchase! You will recieve an email confirmation for your order shortly."
    redirect_to "http://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/products"
  end



end
