class Order < ActiveRecord::Base
  belongs_to :business
  has_many :line_items, dependent: :destroy

  enum status: {
    pending: 0,
    processing: 1,
    delivered: 2,
  }

end
