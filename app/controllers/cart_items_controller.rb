class CartItemsController < ApplicationController

  def create
    # @business = Business.listing_lookup(params[:lookup])
    # CartItem.create(product_id: params[cart_items][product], cart_id: params[cart_items][cart_id])
    # CartItem.create
    CartItem.create(product_id: params[:cart_item][:product_id], cart_id: params[:cart_item][:cart_id])

    redirect_to(:back)

  end


  private

  def location_params
    params.require(:cart_items).permit(
      :quantity,
    )
  end


end
