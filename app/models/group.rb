class Group < ActiveRecord::Base
  include PlacedImageConcern

  default_scope { includes(:blocks) }

  enum kind: { container: 0, full_width: 1 }

  store_accessor :settings, :custom_class, :height, :hero_position, :aspect_ratio, :custom_anchor_id, :background_color, :foreground_color

  has_placed_image :group_background

  belongs_to :webpage

  has_many :blocks, as: :frame, dependent: :destroy

  accepts_nested_attributes_for :blocks, reject_if: :all_blank, allow_destroy: true

  validates :type, presence: true, exclusion: { in: %w[Group] }
  validates :blocks, presence: true

  before_validation do
    self.position = 0 unless position?
  end

  def self.default_scope
    order(position: :asc, created_at: :asc)
  end

  def self.clone

  end

  def clone!
    cloned_group = dup
    cloned_group.blocks << blocks.map(&:clone!)
    cloned_group.save!
    return cloned_group
  end
end
