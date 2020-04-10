class Businesses::ProductsController < Businesses::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions do
    @product = @business.products.new
  end

  before_action only: member_actions do
    @product = @business.products.find(params[:id])
  end

  def index
    @products = @business.products.order('name asc')
  end

  def create
    create_resource @product, product_params, location: [@business, :products]
  end

  def update
    update_resource @product, product_params, location: [@business, :products]
  end

  def destroy
    destroy_resource [@business, @product]
  end

  private

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :delivery_type,
      image_placement_attributes: placement_attributes,
    ).deep_merge(
      image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    )

  end
end
