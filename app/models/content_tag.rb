class ContentTag < ActiveRecord::Base
  belongs_to :business

  has_many :content_taggings
  has_many :content_items, through: :content_taggings

  validates :name, presence: true, uniqueness: { scope: :business }

  def to_param
    "#{id}-#{name}".parameterize
  end
end
