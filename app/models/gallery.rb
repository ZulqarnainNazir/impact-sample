class Gallery < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :business, touch: true

  has_many :gallery_images, dependent: :destroy

  accepts_nested_attributes_for :gallery_images, allow_destroy: true, reject_if: proc { |a|
    a['_destroy'] == '1' || (
      a['title'].blank? &&
      a['description'].blank? &&
      a['gallery_image_placement_attributes'].kind_of?(Hash) &&
      a['gallery_image_placement_attributes'].select { |k,_| !%w[kind image_business image_user].include?(k) }.values.all?(&:blank?)
    )
  }

  validates :business, presence: true
  validates :title, presence: true

  def as_indexed_json(options = {})
    as_json(methods: %i[sorting_date])
  end

  def sorting_date
    created_at
  end

  def to_param
    "#{id}-#{title}".parameterize
  end
end
