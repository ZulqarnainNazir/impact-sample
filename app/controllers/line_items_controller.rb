class LineItemsController < ApplicationController
  include ApplicationHelper

  def create
    if @item = LineItem.where(product_id: params[:line_item][:product_id], cart_id: params[:line_item][:cart_id]).first
      @item.update_attributes(quantity: @item.quantity += 1)
    else
      LineItem.create(product_id: params[:line_item][:product_id], cart_id: params[:line_item][:cart_id])
    end

    redirect_to(:back)

  end

  def update
    @business = Business.listing_lookup(params[:line_item][:lookup])
    @item = LineItem.where(product_id: params[:line_item][:product_id], cart_id: params[:line_item][:cart_id]).first
    @item.update_attributes(quantity: params[:line_item][:quantity])

    # redirect_to(:back)
    redirect_to listing_path_cart_url(@business)

  end

  def destroy

    @business = Business.listing_lookup(params[:lookup])
    @item = LineItem.find(params[:id]).delete

    redirect_to listing_path_cart_url(@business)

  end


  private

  def location_params
    params.require(:line_items).permit(
      :quantity,
    )
  end


end
