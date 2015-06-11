module GroupsAttributesConcern
  extend ActiveSupport::Concern

  private

  def groups_attributes
    [
      :id,
      :type,
      :max_blocks,
      :position,
      :_destroy,
      blocks_attributes: [
        :id,
        :type,
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
        :height,
        :items_limit,
        :_destroy,
        block_background_placement_attributes: placement_attributes,
        block_image_placement_attributes: placement_attributes,
      ]
    ]
  end
end