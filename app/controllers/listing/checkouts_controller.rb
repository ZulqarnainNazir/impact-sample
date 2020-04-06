# require 'search_helper'
class Listing::CheckoutsController < Listing::BaseController
  layout "listing"

  def index
    @business = Business.listing_lookup(params[:lookup])
    @products = @business.products
  end

  def stripe_session
    business = Business.listing_lookup(params[:lookup])
    cart = Cart.find(session[:cart_id])
    items = cart.cart_items.joins(:product).where(products: {business_id: business.id})
    # amount = cart.cart_total(business)

    stripe = StripeService.new(request)
    session = stripe.create_checkout_session(business, items, "http://listings.impact.test:5000/NH-171-mountain-view-publishing-proud-publisher-of-here-in-hanover-image-and-woodstock-magazine", "http://listings.impact.test:5000/NH-171-mountain-view-publishing-proud-publisher-of-here-in-hanover-image-and-woodstock-magazine")

    puts session.id
    render json: { session_id: session.id }

  end

  def create
    flash[:success] = "Thank you for your purchase!"

    # Record Order
    # Empty cart

    # Redirect to lisitng path
    redirect_to root_path
  end



end
