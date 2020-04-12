class Businesses::ArchiveProductsController < Businesses::BaseController
  before_action :set_product

  def create
      if @product.update_attributes!(status: 2)
        redirect_to business_products_path(@product.business)
      else
        redirect_to edit_business_products_path(@product.business), notice: "Something went wrong."
      end
  end

  def destroy
    if @product.update_attributes!(status: 1)
      redirect_to business_products_path(@product.business)
    else
      redirect_to edit_business_products_path(@product.business), notice: "Something went wrong."
    end
  end

  private

  def set_product
    @product = @business.products.find(params[:product_id])
  end

end
