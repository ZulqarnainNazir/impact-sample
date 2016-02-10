module GroupsAttributesConcern
  extend ActiveSupport::Concern

  private

  def groups_attributes
    [
      :id,
      :type,
      :kind,
      :height,
      :max_blocks,
      :position,
      :custom_class,
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
        :well_style,
        :custom_class,
        :content_types,
        :content_category_ids,
        :content_tag_ids,
        :_destroy,
        block_background_placement_attributes: placement_attributes,
        block_image_placement_attributes: placement_attributes,
      ]
    ]
  end
end
