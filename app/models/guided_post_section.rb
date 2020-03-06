class GuidedPostSection < ActiveRecord::Base
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  include PlacedImageConcern

  belongs_to :sectionable, polymorphic: true

  enum kind: {
    image_right: 0,
    image_left: 1,
    full_text: 2,
    full_image: 3,
  }

  has_placed_image :guided_post_section_image

  validates :kind, presence: true
  # validates :sectionable, presence: true
  validates :position, presence: true

  before_validation do
    self.kind = 'full_text' unless kind?
  end
end
