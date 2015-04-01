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
    self.attachment_content_type = 'image/jpg' if attachment_content_type == 'application/octet-stream'
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
    placements.map(&:styles).reject(&:blank?).push(default_styles).inject({}, &:merge)
  end

  def default_styles
    { thumbnail: '160x160#' }
  end

  def business=(*args)
    business.present? ? business : super(*args)
  end

  def user=(*args)
    user.present? ? user : super(*args)
  end

  def react_attributes
    {
      image_id: id,
      image_alt: alt,
      image_title: title,
      image_url: attachment_url,
      image_thumbnail_url: attachment_url(:thumbnail),
      image_file_name: attachment_file_name,
      image_file_size: attachment_file_size,
      image_file_type: attachment_content_type,
    }
  end
end
