class Product < ActiveRecord::Base
  include PlacedImageConcern

  scope :active, -> { where(status: 1) }
  scope :not_archived, -> { where.not(status: 2) }
  scope :archived, -> { where(status: 2) }

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

  enum status: {
    draft: 0,
    active: 1,
    archived: 2,
  }

  enum product_kind: {
    product: 0,
    service: 1,
    gift_card: 2,
    ticket: 3,
    other: 4,
  }

  def locked?
    line_items.where.not(order_id: nil).present?
  end

end
