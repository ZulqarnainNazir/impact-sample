module PlacementAttributesConcern
  extend ActiveSupport::Concern

  private

  def merge_placement_image_attributes(attributes, placement_key)
    if attributes && attributes.kind_of?(Hash)
      placement = attributes[placement_key]
      if placement && placement.kind_of?(Hash)
        placement.merge!(
          image_business: @business,
          image_user: current_user,
        )
      end
    end
  end

  def merge_placement_image_attributes_array(attributes_array, placement_key)
    if attributes_array && attributes_array.kind_of?(Hash)
      attributes_array.each do |_, attributes|
        merge_placement_image_attributes(attributes, placement_key)
      end
    end
  end

  def placement_attributes
    [
      :id,
      :image_id,
      :image_alt,
      :image_title,
      :image_attachment_cache_url,
      :image_attachment_content_type,
      :image_attachment_file_name,
      :image_attachment_file_size,
      :_destroy,
    ]
  end
end