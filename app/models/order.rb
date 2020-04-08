class Order < ActiveRecord::Base
  belongs_to :business
  has_many :line_items, dependent: :destroy

  enum status: {
    pending: 0,
    paid: 1,
    fulfilled: 2,
  }

  def full_name
    "#{first_name} #{last_name}"
  end
end
