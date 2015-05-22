class BeforeAfter < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern

  belongs_to :business

  has_placed_image :before_image
  has_placed_image :after_image

  validates :business, presence: true
  validates :title, presence: true

  def as_indexed_json(options = {})
    as_json(methods: %i[sorting_date])
  end

  def description_html
    Sanitize.fragment(description.to_s, Sanitize::Config::RELAXED).html_safe
  end

  def sorting_date
    created_at
  end

  def to_param
    "#{id}-#{title}".parameterize
  end
end
