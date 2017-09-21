module BlockAttributesConcern
  extend ActiveSupport::Concern

  private

  def block_attributes
    [
      :id,
      :theme,
      :style,
      :layout,
      :position,
      :heading,
      :subheading,
      :text,
      :link_id,
      :link_type,
      :link_version,
      :link_label,
      :link_external_url,
      :link_no_follow,
      :link_target_blank,
      :background_color,
      :foreground_color,
      :link_color,
      :content_types,
      :content_category_ids,
      :company_list_ids,
      :show_our_content,
      :content_tag_ids,
      :include_search,
      :background_aspect_ratio,
      :spoof,
      :_destroy,
    ]
  end
end
