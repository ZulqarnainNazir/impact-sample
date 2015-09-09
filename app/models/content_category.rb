class ContentCategory < ActiveRecord::Base
  belongs_to :business

  has_many :content_categorizations
  has_many :content_items, through: :content_categorizations

  validates :name, presence: true, uniqueness: true

  def to_param
    "#{id}-#{name}".parameterize
  end
end
