class QuickPost < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern

  belongs_to :business

  has_placed_image :quick_post_image

  validates :title, presence: true
  validates :content, presence: true

  def as_indexed_json(options = {})
    as_json(methods: %i[sorting_date])
  end

  def content_html
    Sanitize.fragment(content.to_s, Sanitize::Config::RELAXED).html_safe
  end

  def to_param
    "#{id}-#{title}".parameterize
  end

  def sorting_date
    created_at
  end
end
