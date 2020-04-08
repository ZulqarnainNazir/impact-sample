class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  # belongs_to :order
  # belongs_to :business

  validates :quantity, presence: true
  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 1

end
