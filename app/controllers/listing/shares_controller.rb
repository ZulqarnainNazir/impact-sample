class Listing::SharesController < ApplicationController
  include ApplicationHelper
  before_action do
    @business = Business.listing_lookup(params[:lookup])
  end

  def show

  end
end