module GroupsAttributesConcern
  extend ActiveSupport::Concern

  private

  def groups_attributes
    [
      :id,
      :type,
      :kind,
      :height,
      :background_color,
      :foreground_color,
      :max_blocks,
      :position,
      :hero_position,
      :custom_class,
      :custom_anchor_id,
      :_destroy,
      group_background_placement_attributes: placement_attributes,
      aspect_ratio: [
        :height,
        :width,
      ],
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
        :custom_anchor_id,
        :content_types,
        :content_category_ids,
        :company_list_ids,
        :show_our_content,
        :content_tag_ids,
        :widget_id,
        :contact_form_widget_id,
        :include_search,
        :background_aspect_ratio,
        :_destroy,
        block_background_placement_attributes: placement_attributes,
        block_image_placement_attributes: placement_attributes,
      ]
    ]
  end
end
