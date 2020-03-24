class Cart < ActiveRecord::Base
  has_many :cart_items
  has_many :products, through: :cart_items

  def cart_total(business)
    cart_items.includes(:product).joins(:product).where(products: {business_id: business.id}).map do |item|
      item.product.price * item.quantity
    end.reduce(:+) # map will put the multiplication of (quantity * Unit) into an array then reduce will sum them up
  end

  def cart_item_count(business)
    # cart_items.map do |item|
      cart_items.joins(:product).where(products: {business_id: business.id}).map do |item|
      item.quantity
    end.reduce(:+) # map will put the multiplication of (quantity * Unit) into an array then reduce will sum them up
  end

end
