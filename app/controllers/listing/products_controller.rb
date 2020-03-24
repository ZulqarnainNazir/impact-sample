# require 'search_helper'
class Listing::ProductsController < ApplicationController
  layout "listing"

  def index
    @business = Business.listing_lookup(params[:lookup])
    @products = @business.products
  end

  def show
    @business = Business.listing_lookup(params[:lookup])
    @product = @business.products.find(params[:id])
  end

end
