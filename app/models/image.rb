class Image < ActiveRecord::Base
  belongs_to :business
  belongs_to :user

  has_many :placements, dependent: :destroy
  has_many :placers, through: :placements

  validates :business_id, presence: true, unless: :business
  validates :user_id, presence: true, unless: :user
  # validates :attachment_cache_url, :attachment_content_type, :attachment_file_size, presence: true
  validates :attachment_cache_url, presence: true
  validates :attachment_cache_url, format: { with: /\A((http\:)|(https\:))?\/\// }
  #validates :attachment_content_type, format: { with: /\Aimage\/.*\Z/ }
  #validates :attachment_file_size, inclusion: { in: 0..10.megabytes }

  serialize :processed_styles

  before_validation do
    self.attachment_updated_at = Time.zone.now if attachment_cache_url_changed? && attachment_cache_url?
    self.attachment_content_type = 'image/jpg' if attachment_content_type == 'application/octet-stream'
  end

  after_create do
    return if attachment_cache_url.present? && attachment_cache_url.include?(Rails.application.secrets.aws_s3_bucket)
    api_endpoint = Rails.application.secrets.lambda_api_endpoint
    api_key = Rails.application.secrets.lambda_api_key

    s3_path = URI.parse(attachment_cache_url).path

    HTTParty.post(api_endpoint, body: { facebook_image_url: attachment_cache_url,
                                        api_key: api_key }.to_json)

    update(attachment_cache_url: "http://#{Rails.application.secrets.aws_s3_bucket}.s3.amazonaws.com/_originals/_fb#{s3_path}")
  end

  after_destroy do
    delete_from_s3
  end

  after_commit do
    placements.each(&:touch)
  end

  def attachment_url?
    attachment_cache_url?
  end

<<<<<<< ac0b9af18769cb39fec720184b1a526e139e32b1
  def attachment_url(style = :thumbnail)
    return attachment_cache_url if style.blank? || attachment_cache_url.blank? || style == :original

    resized_key = s3_key(style)

    if processed_styles.present? && processed_styles.include?(style)
      cdn_resized_url(resized_key)
    else
      if s3_bucket.objects[resized_key].exists?
        processed_styles ||= []
        processed_styles << style
        save
        cdn_resized_url(resized_key)
      else
        '/assets/spinner.gif'
      end
    end
=======
  def attachment_url(style = nil)
    return attachment_cache_url if style.blank?
    attachment_cache_url.gsub('_original/', "r/#{style}/")
>>>>>>> Switch to Lambda-based resizing
  end

  def s3_bucket
    @s3_bucket ||= AWS::S3.new.buckets[Rails.application.secrets.aws_s3_bucket]
  end

  def cdn_resized_url(resized_key)
    "#{ENV['AWS_CLOUDFRONT_HOST']}/#{resized_key}"
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
        URI.escape(url)
      ).path[1..-1]
    )
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
    return attachment_url(:logo_medium) if attachment_cache_url.present? && attachment_cache_url.include?('_logos')
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
