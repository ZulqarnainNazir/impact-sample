class Image < ActiveRecord::Base
  belongs_to :business
  belongs_to :user

  has_many :placements, dependent: :destroy
  has_many :placers, through: :placements

  has_attached_file :attachment, styles: lambda { |attachment| attachment.instance.styles }

  validates :business, presence: true
  validates :user, presence: true

  validates_attachment_presence :attachment, unless: :attachment_cache_url?
  validates_attachment_content_type :attachment, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :attachment, in: 0..10.megabytes

  before_validation do
    self.attachment_updated_at = Time.zone.now if attachment_cache_url_changed? && attachment_cache_url?
  end

  after_commit do
    ImageCacheTransferJob.perform_later(self) if attachment_cache_url?
  end

  def attachment_url(style = nil)
    if attachment_cache_url?
      attachment_cache_url
    elsif attachment?
      attachment.url(style)
    end
  end

  def attachment_url?
    attachment_cache_url? || attachment?
  end

  def styles
    placements.map(&:styles).reject(&:blank?).inject({}, &:merge)
  end

  def business=(*args)
    business.present? ? business : super(*args)
  end

  def user=(*args)
    user.present? ? user : super(*args)
  end
end
