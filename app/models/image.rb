class Image < ActiveRecord::Base
  belongs_to :business
  belongs_to :user

  has_many :placements, dependent: :destroy
  has_many :placers, through: :placements

  validates :business_id, presence: true, unless: :business
  validates :user_id, presence: true, unless: :user
  validates :attachment_cache_url, :attachment_content_type, :attachment_file_size, presence: true
  validates :attachment_cache_url, format: { with: /\A((http\:)|(https\:))?\/\// }
  validates :attachment_content_type, format: { with: /\Aimage\/.*\Z/ }
  validates :attachment_file_size, inclusion: { in: 0..10.megabytes }

  before_validation do
    self.attachment_updated_at = Time.zone.now if attachment_cache_url_changed? && attachment_cache_url?
    self.attachment_content_type = 'image/jpg' if attachment_content_type == 'application/octet-stream'
  end

  after_commit do
    placements.each(&:touch)
  end

  def attachment_url?
    attachment_cache_url?
  end

  def attachment_url(style = nil)
    return attachment_cache_url if style.blank?
    attachment_cache_url.gsub('_original/', "r/#{style}/")
  end

  def styles
    {
      thumbnail: '260x260#',
      jumbo: '1200x100000>',
      jumbo_fixed: '1200x',
      large: '800x100000>',
      large_fixed: '800x',
      medium: '600x100000>',
      medium_fixed: '600x',
      small: '400x100000>',
      small_fixed: '400x',
      logo_small: 'x40',
      logo_medium: 'x60',
      logo_large: 'x125',
      logo_jumbo: 'x200',
    }.slice(*placements.map(&:style_keys).push(%i[thumbnail medium large_fixed jumbo_fixed]).flatten.uniq)
  end

  def attachment_thumbnail_url
    attachment_url(:thumbnail)
  end

  def attachment_small_url
    attachment_url(:small)
  end

  def attachment_small_fixed_url
    attachment_url(:small_fixed)
  end

  def attachment_medium_url
    attachment_url(:medium)
  end

  def attachment_medium_fixed_url
    attachment_url(:medium_fixed)
  end

  def attachment_large_url
    attachment_url(:large)
  end

  def attachment_large_fixed_url
    attachment_url(:large_fixed)
  end

  def attachment_jumbo_url
    attachment_url(:jumbo)
  end

  def attachment_jumbo_fixed_url
    attachment_url(:jumbo_fixed)
  end
end
