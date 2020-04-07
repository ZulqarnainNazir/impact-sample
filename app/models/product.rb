class Product < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :business

  has_placed_image :image

  validates :business, :name, :description, :price, presence: true

end
