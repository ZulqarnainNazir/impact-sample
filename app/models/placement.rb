class Placement < ActiveRecord::Base
  belongs_to :placer, polymorphic: true, touch: true
  belongs_to :image

  enum kind: {
    images: 0,
    embeds: 1,
  }

  accepts_nested_attributes_for :image, reject_if: :all_blank

  validates :placer, presence: true
  validates :image, presence: true, if: :images?
  validates :embed, presence: true, if: :embeds?

  before_validation do
    self.kind = 'images' unless kind?
  end

  def placer_location
    case context
    when 'logo'
      Rails.application.routes.url_helpers.edit_business_data_details_path(placer)
    when 'team_member_profile'
      Rails.application.routes.url_helpers.edit_business_data_team_member_path(placer.business, placer)
    when 'about_block_image'
      placer_block_location
    when 'hero_block_image'
      placer_block_location
    when 'call_to_action_block_image'
      placer_block_location
    when 'content_block_image'
      placer_block_location
    when 'before_image'
      Rails.application.routes.url_helpers.edit_business_content_before_after_path(placer.business, placer)
    when 'after_image'
      Rails.application.routes.url_helpers.edit_business_content_before_after_path(placer.business, placer)
    when 'gallery_image'
      Rails.application.routes.url_helpers.edit_business_content_gallery_path(placer.gallery.business, placer.gallery)
    end
  end

  def placer_block_location
    case placer.frame.type
    when 'HomePage'
      Rails.application.routes.url_helpers.edit_business_website_home_page_path(placer.frame.website.business, placer.frame)
    when 'AboutPage'
      Rails.application.routes.url_helpers.edit_business_website_about_page_path(placer.frame.website.business, placer.frame)
    when 'BlogPage'
      Rails.application.routes.url_helpers.edit_business_website_blog_page_path(placer.frame.website.business, placer.frame)
    when 'ContactPage'
      Rails.application.routes.url_helpers.edit_business_website_contact_page_path(placer.frame.website.business, placer.frame)
    when 'CustomPage'
      Rails.application.routes.url_helpers.edit_business_website_custom_page_path(placer.frame.website.business, placer.frame)
    end
  end

  def style_keys
    Hash.new([]).merge(
      block_image: %i[small small_fixed medium medium_fixed jumbo jumbo_fixed],
      block_background: %i[jumbo],
      group_background: %i[jumbo],
      after_image: %i[medium],
      before_image: %i[medium],
      event_image: %i[thumbnail medium],
      gallery_image: %i[thumbnail large],
      logo: %i[logo_small logo_medium logo_large logo_jumbo thumbnail],
      offer_image: %i[medium],
      post_section_image: %i[thumbnail medium],
      quick_post: %i[large],
      team_member_profile: %i[small],
    )[context.try(:to_sym)].flatten.uniq
  end

  def image_alt
    image.try(:alt)
  end

  def image_title
    image.try(:title)
  end

  def image_attachment_url
    image.try(:attachment_url)
  end

  def image_attachment_thumbnail_url
    image.try(:attachment_thumbnail_url)
  end

  def image_attachment_small_url
    image.try(:attachment_small_url)
  end

  def image_attachment_small_fixed_url
    image.try(:attachment_small_fixed_url)
  end

  def image_attachment_medium_url
    image.try(:attachment_medium_url)
  end

  def image_attachment_medium_fixed_url
    image.try(:attachment_medium_fixed_url)
  end

  def image_attachment_large_url
    image.try(:attachment_large_url)
  end

  def image_attachment_large_fixed_url
    image.try(:attachment_large_fixed_url)
  end

  def image_attachment_jumbo_url
    image.try(:attachment_jumbo_url)
  end

  def image_attachment_jumbo_fixed_url
    image.try(:attachment_jumbo_fixed_url)
  end

  def image_attachment_content_type
    image.try(:attachment_content_type)
  end

  def image_attachment_file_name
    image.try(:attachment_file_name)
  end

  def image_attachment_file_size
    image.try(:attachment_file_size)
  end
end
