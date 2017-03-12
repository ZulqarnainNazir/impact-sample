class PostSection < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern

  attr_accessor :cached_children, :key, :parent_key

  enum kind: {
    image_right: 0,
    image_left: 1,
    full_text: 2,
    full_image: 3,
  }

  belongs_to :post, touch: true

  has_ancestry

  has_placed_image :post_section_image

  validates :kind, presence: true
  validates :post, presence: true
  
  validates_presence_of :content

  before_validation do
    self.kind = 'image_right' unless kind?
  end
end
