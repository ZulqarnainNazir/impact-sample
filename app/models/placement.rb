class Placement < ActiveRecord::Base
  belongs_to :placer, polymorphic: true
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

  after_save do
    ImageAttachmentReprocessJob.perform_later(image) if image && image_id_changed?
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
    when 'specialty_block_image'
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

  def styles
    context? && respond_to?(context) ? send(context) : {}
  end

  def gallery_image
    {
      gallery_image_small: '200x200#',
      gallery_image_large: 'x800',
    }
  end

  def logo
    {
      logo_small: 'x40',
      logo_medium: 'x60',
      logo_large: 'x125',
      logo_jumbo: 'x200',
      logo_square: '200x200#',
    }
  end

  def team_member_profile
    {
      team_member_profile_small: 'x165',
      team_member_profile_large: 'x360',
    }
  end

  def post_section_image
    {
      post_section_half: 'x500',
    }
  end

  def offer_image
    {
      offer_half: 'x600',
    }
  end

  def content_block_image
    {
      content_block_image_half: 'x400',
    }
  end

  def sidebar_content_block_image
    {
      sidebar_content_block_image: 'x400',
    }
  end
end
