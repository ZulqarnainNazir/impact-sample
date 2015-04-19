class ProjectImage < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :project, touch: true

  has_placed_image :project_image

  validates :project, presence: true

  def description_html
    Sanitize.fragment(description.to_s, Sanitize::Config::RELAXED).html_safe
  end
end
