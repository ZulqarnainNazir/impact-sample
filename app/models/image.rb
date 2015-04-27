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
    self.attachment_content_type ||= Paperclip::ContentTypeDetector.new(attachment_file_name).detect
    # TODO: Cannot get all image content types to be detected properly. Possible security risk.
    self.attachment_content_type = 'image/jpg' if attachment_content_type == 'application/octet-stream'
  end

  after_commit do
    ImageCacheTransferJob.perform_later(self) if attachment_cache_url?
  end

  def attachment_url?
    attachment_cache_url? || attachment?
  end

  def attachment_url(style = nil)
    if attachment_cache_url?
      attachment_cache_url
    elsif attachment?
      attachment.url(style)
    end
  end

  def styles
    placements.map(&:styles).reject(&:empty?).push(default_styles).inject(:merge)
  end

  def attachment_thumbnail_url
    attachment_url(:thumbnail)
  end

  private

  def default_styles
    { thumbnail: '260x260#' }
  end
end
