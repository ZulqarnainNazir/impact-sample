class Image < ActiveRecord::Base
  belongs_to :business
  belongs_to :user

  has_many :placements, dependent: :destroy
  has_many :placers, through: :placements

  has_attached_file :attachment, styles: lambda { |attachment| attachment.instance.styles }

  validates :business_id, presence: true, unless: :business
  validates :user_id, presence: true, unless: :user
  validates :attachment_cache_url, format: { with: /\A((http\:)|(https\:))?\/\// }, allow_nil: true

  validates_attachment_presence :attachment, unless: :attachment_cache_url?
  validates_attachment_content_type :attachment, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :attachment, in: 0..10.megabytes

  before_validation do
    self.attachment_updated_at = Time.zone.now if attachment_cache_url_changed? && attachment_cache_url?
    self.attachment_content_type ||= Paperclip::ContentTypeDetector.new(attachment_file_name).detect
    # TODO: Cannot get all image content types to be detected properly. Possible security risk.
    self.attachment_content_type = 'image/jpg' if attachment_content_type == 'application/octet-stream'
  end

  after_commit do
    ImageCacheTransferJob.perform_later(self) if attachment_cache_url?
    placements.each(&:touch)
  end

  after_post_process do
    update_column :cached_styles, styles.keys
  end

  def attachment_url?
    attachment_cache_url? || attachment?
  end

  def attachment_url(style = nil)
    if attachment_cache_url?
      attachment_cache_url
    elsif attachment? && style && cached_styles.try(:include?, style.to_s)
      attachment.url(style)
    elsif attachment? && style && style.match(/_fixed\z/) && cached_styles.try(:include?, 'jumbo_fixed')
      attachment.url(:jumbo_fixed)
    elsif attachment?
      attachment.url
    end
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
    }.slice(*placements.map(&:style_keys).push(%i[thumbnail medium jumbo_fixed]).flatten.uniq)
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
