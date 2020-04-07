# require 'search_helper'
class Listing::CheckoutsController < Listing::BaseController
  layout "listing"

  def index
    @business = Business.listing_lookup(params[:lookup])
    @products = @business.products
  end

  def new
    business = Business.listing_lookup(params[:lookup])
    cart = Cart.find(session[:cart_id])
    items = cart.cart_items.joins(:product).where(products: {business_id: business.id})
    shipping_required = items.where(products: {require_shipping_address: true}).present?

    stripe = StripeService.new(request)
    session = stripe.create_checkout_session(business, items, shipping_required, "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/checkout/create", "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/checkout")

    render json: { session_id: session.id }

  end

  def create

    business = Business.listing_lookup(params[:lookup])
    cart = Cart.find(session[:cart_id])
    items = cart.cart_items.joins(:product).where(products: {business_id: business.id})


    # Record Order
    # Order.new(business, items, status)

    # Empty cart
    items.delete_all


    # Redirect to lisitng product path
    flash[:success] = "Thank you for your purchase! You will recieve an email confirmation for your order shortly."
    redirect_to "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/products"
  end



end
