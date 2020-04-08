class Order < ActiveRecord::Base
  belongs_to :business
  has_many :line_items, dependent: :destroy

  private

  def full_name
    "#{first_name} #{last_name}"
  end
end
