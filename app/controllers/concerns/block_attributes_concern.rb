module BlockAttributesConcern
  extend ActiveSupport::Concern

  private

  def block_attributes
    [
      :id,
      :theme,
      :style,
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
      :spoof,
      :_destroy,
    ]
  end
end
