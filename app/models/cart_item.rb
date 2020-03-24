class CartItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart

  validates :quantity, presence: true
  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 1

end
