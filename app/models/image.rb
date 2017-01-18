class Image < ActiveRecord::Base
  belongs_to :business
  belongs_to :user

  has_many :placements, dependent: :destroy
  has_many :placers, through: :placements

  validates :business_id, presence: true, unless: :business
  validates :user_id, presence: true, unless: :user
  validates :attachment_cache_url, presence: true
  validates :attachment_cache_url, format: { with: /\A((http\:)|(https\:))?\/\// }
  validates :attachment_content_type, presence: true, format: { with: /\Aimage\/.*\Z/ }, unless: :facebook?
  validates :attachment_file_size, presence: true, inclusion: { in: 0..10.megabytes }, unless: :facebook?

  serialize :processed_styles

  before_validation do
    self.attachment_updated_at = Time.zone.now if attachment_cache_url? && attachment_cache_url_changed?
    self.attachment_content_type = 'image/jpg' if attachment_content_type == 'application/octet-stream'
  end

  after_create do
    if attachment_cache_url.present? && attachment_cache_url.include?('fbcdn.net')
      api_endpoint = Rails.application.secrets.lambda_api_endpoint
      api_key = Rails.application.secrets.lambda_api_key

      s3_path = URI.parse(attachment_cache_url).path

      HTTParty.post(api_endpoint, body: { facebook_image_url: attachment_cache_url,
                                          bucket: Rails.application.secrets.aws_s3_bucket,
                                          api_key: api_key }.to_json)

      update(attachment_cache_url: "//#{Rails.application.secrets.aws_s3_bucket}.s3.amazonaws.com/_originals/_fb#{s3_path}")
    end
  end

  after_destroy do
    delete_from_s3
  end

  after_commit do
    placements.each(&:touch)
  end

  def facebook?
    attachment_cache_url.present? &&
      ( attachment_cache_url.include?('_fb') || attachment_cache_url.include?('fbcdn.net') )
  end

  def attachment_url(style = :thumbnail)
    return attachment_cache_url if attachment_cache_url.blank? || style == :original

    resized_key = s3_key(style)

    if self.processed_styles.present? && self.processed_styles.include?(style)
      cdn_resized_url(resized_key)
    else
      if s3_bucket.objects[resized_key].exists?
        self.processed_styles ||= []
        self.processed_styles << style
        update(processed_styles: self.processed_styles)
        cdn_resized_url(resized_key)
      else
        "#{ActionController::Base.helpers.asset_path('spinner.gif')}"
      end
    end
  end

  def s3_bucket
    @s3_bucket ||= AWS::S3.new.buckets[Rails.application.secrets.aws_s3_bucket]
  end

  def cdn_resized_url(resized_key)
    URI.escape("//#{ENV['AWS_CLOUDFRONT_HOST']}/#{resized_key}")
  end

  def s3_key(style = nil)
    url = if style.present?
            attachment_cache_url.gsub('_originals/', "r/#{style}/")
                                .gsub('_logos/', "r/#{style}/")
          else
            attachment_cache_url
          end
    URI.unescape(
      URI.parse(
        URI.escape(url).gsub("[","%5B").gsub("]","%5D")
      ).path[1..-1]
    )
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
    return attachment_url(:logo_medium) if attachment_cache_url.present? && attachment_cache_url.include?('_logos')
    attachment_url(:medium)
  end

  def attachment_medium_fixed_url
    attachment_url(:medium_fixed)
  end

  def attachment_large_url
    return attachment_url(:logo_large) if attachment_cache_url.present? && attachment_cache_url.include?('_logos')
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

  def delete_from_s3
    return unless attachment_cache_url.present?

    resizes = if attachment_cache_url.include?('_logos/')
                [:logo_small, :logo_medium, :logo_large, :logo_jumbo, :thumbnail, :medium, nil]
              else
                [:thumbnail, :jumbo, :jumbo_fixed, :large, :large_fixed, :medium, :medium_fixed, :small, :small_fixed, nil]
              end
    resizes.each do |size|
      s3_bucket.objects[s3_key(size)].delete
    end
  end
end
