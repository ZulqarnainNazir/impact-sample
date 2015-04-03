class Block < ActiveRecord::Base
  include PlacedImageConcern

  attr_accessor(
    :image_placement_id,
    :image_placement_destroy,
    :image_id,
    :image_cache_url,
    :image_alt,
    :image_title,
    :image_file_name,
    :image_file_size,
    :image_content_type,
    :image_business,
    :image_user,
  )

  enum link_version: {
    link_none: 0,
    link_internal: 1,
    link_external: 2,
  }

  belongs_to :frame, polymorphic: true, touch: true
  belongs_to :link, polymorphic: true

  validates :theme, presence: true
  validates :type, presence: true, exclusion: { in: %w[Block] }

  def image_accessors?
    [
      :image_placement_id,
      :image_placement_destroy,
      :image_id,
      :image_cache_url,
      :image_alt,
      :image_title,
      :image_file_name,
      :image_file_size,
      :image_content_type,
    ].any? do |attr|
      send(attr).present?
    end
  end

  def image_accessor_attributes
    accessor_attributes = {
      id: image_placement_id,
      _destroy: image_placement_destroy,
      image_attributes: {
        alt: image_alt,
        title: image_title,
      }
    }

    if image_id.present?
      accessor_attributes.deep_merge(
        image_id: image_id,
        image_attributes: {
          id: image_id,
        }
      )
    else
      accessor_attributes.deep_merge(
        image_attributes: {
          attachment_file_name: image_file_name,
          attachment_file_size: image_file_size,
          attachment_content_type: image_content_type,
          user: image_user,
          business: image_business,
        }
      )
    end
  end

  def react_attributes(image = nil, placement = nil)
    if image && image.is_a?(Image)
      attributes.merge(
        image_id: image.id,
        image_placement_id: placement.id,
        image_alt: image.alt,
        image_title: image.title,
        image_url: image.attachment_url,
        image_cache_url: image_cache_url || image.attachment_cache_url,
        image_file_name: image_file_name || image.attachment_file_name,
        image_file_size: image_file_size || image.attachment_file_size,
        image_file_type: image_content_type || image.attachment_content_type,
        image_state: 'attached',
      )
    elsif image_cache_url.present?
      attributes.merge(
        image_url: image_cache_url,
        image_cache_url: image_cache_url,
        image_file_name: image_file_name,
        image_file_size: image_file_size,
        image_file_type: image_content_type,
        image_state: 'attached',
      )
    else
      attributes.merge(
        image_state: 'empty',
      )
    end.merge(
      key: (rand * 10 ** 10).to_i,
      link_version: link_version,
    )
  end

  def link_external_url=(value)
    if value.to_s.match(/\Ahttp/)
      super(value.to_s)
    else
      super("http://#{value}")
    end
  end

  def heading_html
    heading
  end

  def subheading_html
    subheading
  end

  def text_html
    Sanitize.fragment(text.to_s, Sanitize::Config::BASIC).html_safe
  end

  def button?
    (link_version == 'link_internal' && link_label? && link.present?) ||
    (link_version == 'link_external' && link_label? && link_external_url?)
  end

  def link_location
    if link_version == 'link_internal'
      link.pathname.blank? ? '/' : Rails.application.routes.url_helpers.website_custom_page_path(link.pathname)
    elsif link_version == 'link_external'
      link_external_url
    end
  end
end
