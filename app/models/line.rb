class Line < ActiveRecord::Base
  belongs_to :business, touch: true

  validates :business, presence: true
  validates :title, presence: true
  validates :type, presence: true, exclusion: { in: %w[Line] }
end
