class Categorization < ActiveRecord::Base
  # belongs_to :business
  belongs_to :categorizable, polymorphic: true
  belongs_to :category

  # validates :business, presence: true
  validates :categorizable, presence: true
  validates :category, presence: true
end
