class Line < ActiveRecord::Base
  belongs_to :business, touch: true

  has_many :line_images, dependent: :destroy

  accepts_nested_attributes_for :line_images, allow_destroy: true, reject_if: proc { |a|
    a['_destroy'] == '1' || (
      a['line_image_placement_attributes'].kind_of?(Hash) &&
      a['line_image_placement_attributes'].select { |k,_| !%w[kind image_business image_user].include?(k) }.values.all?(&:blank?)
    )
  }

  validates :business, presence: true
  validates :title, presence: true
  validates :type, presence: true, exclusion: { in: %w[Line] }
end
