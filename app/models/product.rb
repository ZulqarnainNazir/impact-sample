class Product < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :business

  has_many :line_items, dependent: :destroy

  has_placed_image :image

  validates :business, :name, :description, :price, presence: true

end
