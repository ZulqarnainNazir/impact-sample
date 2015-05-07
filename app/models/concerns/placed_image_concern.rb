module PlacedImageConcern
  extend ActiveSupport::Concern

  class_methods do
    def has_placed_image(association_name)
      association_name = association_name.to_sym
      placement_name = "#{association_name}_placement".to_sym

      has_one placement_name, -> { where(context: association_name) }, as: :placer, class_name: Placement.name, dependent: :destroy
      has_one association_name, through: placement_name, source: :image

      accepts_nested_attributes_for placement_name, allow_destroy: true, reject_if: :all_blank

      define_method "#{placement_name}_attributes=" do |attr = {}|
        attr = attr.with_indifferent_access
        if attr[:image_id].present?
          super(
            id: attr[:id],
            placer: self,
            context: association_name,
            image_id: attr[:image_id],
            image_attributes: {
              id: attr[:image_id],
              alt: attr[:image_alt],
              title: attr[:image_title],
            },
            embed: nil,
            _destroy: attr[:_destroy],
          )
        elsif attr[:image_attachment_cache_url].present?
          super(
            id: attr[:id],
            placer: self,
            context: association_name,
            image_attributes: {
              alt: attr[:image_alt],
              title: attr[:image_title],
              attachment_cache_url: attr[:image_attachment_cache_url],
              attachment_content_type: attr[:image_attachment_content_type],
              attachment_file_name: attr[:image_attachment_file_name],
              attachment_file_size: attr[:image_attachment_file_size],
              business: attr[:image_business],
              user: attr[:image_user],
            },
            embed: nil,
            _destroy: attr[:_destroy],
          )
        elsif attr[:embed].present?
          super(
            id: attr[:id],
            placer: self,
            context: association_name,
            embed: attr[:embed],
            _destroy: attr[:_destroy],
          )
        elsif attr[:id].present?
          super(
            id: attr[:id],
            placer: self,
            context: association_name,
            _destroy: attr[:_destroy],
          )
        end
      end

      define_method "#{placement_name}_json" do |*args|
        placement = send(placement_name) || send("build_#{placement_name}")
        placement.build_image unless placement.image
        placement.as_json(include: { image: { methods: :attachment_thumbnail_url }})
      end
    end
  end
end
