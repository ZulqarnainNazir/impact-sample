class Cart < ActiveRecord::Base
  has_many :cart_items
  has_many :products, through: :cart_items

  def cart_total
    cart_items.includes(:product).map do |item|
      item.product.price * item.quantity
    end.reduce(:+) # map will put the multiplication of (quantity * Unit) into an array then reduce will sum them up
  end

end
