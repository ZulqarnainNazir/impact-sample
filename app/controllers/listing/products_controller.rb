# require 'search_helper'
class Listing::ProductsController < Listing::BaseController
  layout "listing"

  before_action do
    @business = Business.listing_lookup(params[:lookup])
  end

  before_action do
    unless @business.stripe_connected_account_id.present?
      redirect_to "https://#{ENV['LISTING_HOST']}#{@business.generate_listing_path}", notice: 'You are not permitted there.'
    end
  end

  def index
    # @business = Business.listing_lookup(params[:lookup])
    @products = @business.products.active
  end

  def show
    # @business = Business.listing_lookup(params[:lookup])
    @product = @business.products.active.find(params[:id])

    @products = @business.products
  end

end
