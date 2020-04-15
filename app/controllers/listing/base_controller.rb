# require 'search_helper'
class Listing::BaseController < ApplicationController

  before_action do
    begin
      @cart = Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
       @cart = Cart.create
       session[:cart_id] = @cart.id
    end
  end

end
