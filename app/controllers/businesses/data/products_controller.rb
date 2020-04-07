class Businesses::Data::ProductsController < Businesses::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions do
    @product = @business.products.new
  end

  before_action only: member_actions do
    @product = @business.products.find(params[:id])
  end

  def index
    @products = @business.products
  end

  def create
    create_resource @product, product_params, location: [@business, :data_products]
  end

  def update
    update_resource @product, product_params, location: [@business, :data_products]
  end

  def destroy
    destroy_resource [@business, :data, @product]
  end

  private

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :require_shipping_address,
      image_placement_attributes: placement_attributes,
    ).deep_merge(
      image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    )

  end
end
