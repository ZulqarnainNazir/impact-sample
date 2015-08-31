class Webpage < ActiveRecord::Base
  include PlacedImageConcern

  store_accessor :settings, :external_line_id, :sidebar_position

  belongs_to :website

  has_many :groups, dependent: :destroy
  has_many :linked_blocks, as: :link, class_name: Block.name
  has_many :nav_links

  has_placed_image :main_image

  with_options allow_destroy: true, reject_if: :all_blank do
    accepts_nested_attributes_for :groups
  end

  validates :pathname, uniqueness: { scope: :website, case_sensitive: false }
  validates :pathname, absence: true, if: -> { type == 'HomePage' }
  validates :pathname, presence: true, format: { with: /\A\w+[\w\-\/]*\w+\z/ }, unless: -> { type == 'HomePage' }
  validates :title, presence: true
  validates :type, presence: true, exclusion: { in: %w[Webpage] }

  before_validation do
    self.name = title if !name? && title?
    self.pathname = title.parameterize if !pathname? && title? && type != 'HomePage'
  end

  def self.custom
    where(type: 'CustomPage')
  end

  def main_image
    super.try(:attachment_url) ||
      Block.where(type: 'HeroBlock', frame_type: 'Group', frame_id: group_ids).first.try(:block_image).try(:attachment_url) ||
      Block.where(type: 'SpecialtyBlock', frame_type: 'Group', frame_id: group_ids).first.try(:block_image).try(:attachment_url)
  end

  def sidebar_position
    super == 'left' ? 'left' : 'right'
  end

  def sidebar_reverse_position
    sidebar_position == 'left' ? 'right' : 'left'
  end
end
