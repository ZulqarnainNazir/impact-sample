# require 'search_helper'
class Listing::CheckoutsController < Listing::BaseController
  layout "listing"

  def index
    @business = Business.listing_lookup(params[:lookup])
    @products = @business.products
  end



end
