class Gallery < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern

  belongs_to :business, touch: true

  has_many :content_categories, through: :content_categorizations
  has_many :content_categorizations, as: :content_item
  has_many :content_taggings, as: :content_item
  has_many :content_tags, through: :content_taggings
  has_many :gallery_images, dependent: :destroy

  has_placed_image :main_image

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
    as_json(methods: %i[content_category_ids content_tag_ids sorting_date])
  end

  def sorting_date
    created_at
  end

  def to_param
    "#{id}-#{title}".parameterize
  end
end
