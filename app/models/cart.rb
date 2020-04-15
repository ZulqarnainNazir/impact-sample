class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items

  def cart_total(business)
    line_items.includes(:product).joins(:product).where(products: {business_id: business.id, status: 1}).map do |item|
      item.product.price * item.quantity
    end.reduce(:+) # map will put the multiplication of (quantity * Unit) into an array then reduce will sum them up
  end

  def line_item_count(business)
    line_items.joins(:product).where(products: {business_id: business.id, status: 1}).map do |item|
      item.quantity
    end.reduce(:+) # map will put the multiplication of (quantity * Unit) into an array then reduce will sum them up
  end

end
