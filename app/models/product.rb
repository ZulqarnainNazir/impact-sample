class Product < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :business

  has_many :line_items, dependent: :destroy

  has_placed_image :image

  validates :business, :name, :description, :price, presence: true

  enum delivery_type: {
    pickup: 0,
    electronic: 1,
    delivery: 2,
    ship: 3,
  }

end
