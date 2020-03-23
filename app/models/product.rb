class Product < ActiveRecord::Base

  belongs_to :business

  validates :business, :name, :description, :price, presence: true
end
