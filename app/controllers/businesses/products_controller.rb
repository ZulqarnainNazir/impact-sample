class Businesses::ProductsController < Businesses::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions do
    @product = @business.products.new
  end

  before_action only: member_actions do
    @product = @business.products.find(params[:id])
  end

  def index
    @products = @business.products.not_archived.order('name asc')
    @archived_products = @business.products.archived.order('name asc')
  end

  def create
    create_resource @product, product_params, location: [@business, :products]
  end

  def update
    unless @product.locked?
      update_resource @product, product_params, location: [@business, :products]
    end
  end

  def destroy
    unless @product.locked?
      destroy_resource [@business, @product]
    end
  end

  private

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :delivery_type,
      :status,
      :product_kind,
      image_placement_attributes: placement_attributes,
    ).deep_merge(
      image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    )

  end
end
