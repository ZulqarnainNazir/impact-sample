class CartItemsController < ApplicationController
  include ApplicationHelper

  def create
    if @item = CartItem.where(product_id: params[:cart_item][:product_id], cart_id: params[:cart_item][:cart_id]).first
      @item.update_attributes(quantity: @item.quantity += 1)
    else
      CartItem.create(product_id: params[:cart_item][:product_id], cart_id: params[:cart_item][:cart_id])
    end

    redirect_to(:back)

  end

  def update
    @business = Business.listing_lookup(params[:cart_item][:lookup])
    @item = CartItem.where(product_id: params[:cart_item][:product_id], cart_id: params[:cart_item][:cart_id]).first
    @item.update_attributes(quantity: params[:cart_item][:quantity])

    # else
    #   CartItem.create(product_id: params[:cart_item][:product_id], cart_id: params[:cart_item][:cart_id])
    # end

    # redirect_to(:back)
    redirect_to listing_path_checkout_url(@business)

  end

  def destroy

    @business = Business.listing_lookup(params[:lookup])
    # @item = CartItem.where(product_id: params[:cart_item][:product_id], cart_id: params[:cart_item][:cart_id]).first.delete
    @item = CartItem.find(params[:id]).delete

    redirect_to listing_path_checkout_url(@business)

  end


  private

  def location_params
    params.require(:cart_items).permit(
      :quantity,
    )
  end


end
