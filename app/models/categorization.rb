class Categorization < ActiveRecord::Base
  belongs_to :business
  belongs_to :category

  validates :business, presence: true
  validates :category, presence: true
end
