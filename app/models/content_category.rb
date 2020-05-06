class ContentCategory < ActiveRecord::Base
  belongs_to :business

  has_many :content_categorizations
  has_many :content_items, through: :content_categorizations

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false, scope: :business_id

  before_validation do
    self.name = self.name.titleize if name.present?
  end

  def to_param
    "#{id}-#{name}".parameterize
  end
end
