class Categorization < ActiveRecord::Base
  # belongs_to :business
  belongs_to :categorizable, polymorphic: true
  belongs_to :category

  # We are allowing this to be created without a categorizable for now,
  # so that we may build a new location, business, and categorization and save
  # them all without triggering validation errors. See locations_controller.rb
  # validates :categorizable, presence: true
  validates :category, presence: true
end
