module PlacedImageConcern
  extend ActiveSupport::Concern

  class_methods do
    def has_placed_image(association_name)
      association_name = association_name.to_sym
      placement_name = "#{association_name}_placement".to_sym

      has_one placement_name, -> { where(context: association_name) }, as: :placer, class_name: Placement.name, dependent: :destroy
      has_one association_name, through: placement_name, source: :image

      accepts_nested_attributes_for placement_name, allow_destroy: true, reject_if: :all_blank

      define_method "#{placement_name}_attributes=" do |inputs = {}|
        inputs = inputs.with_indifferent_access

        outputs = {
          id: inputs[:id],
          kind: inputs[:kind],
          full_width: !!inputs[:full_width],
          placer: self,
          context: association_name,
          _destroy: inputs[:_destroy],
        }

        if inputs[:kind] == 'embeds'
          super outputs.merge!(
            embed: inputs[:embed],
            image_id: nil,
            image_attributes: {},
          )
        elsif inputs[:image_id].present?
          super outputs.merge!(
            embed: nil,
            image_id: inputs[:image_id],
            image_attributes: {
              id: inputs[:image_id],
              alt: inputs[:image_alt],
              title: inputs[:image_title],
            },
          )
        elsif inputs[:image_attachment_cache_url].present?
          super outputs.merge!(
            embed: nil,
            image_id: nil,
            image_attributes: {
              alt: inputs[:image_alt],
              title: inputs[:image_title],
              attachment_cache_url: inputs[:image_attachment_cache_url],
              attachment_content_type: inputs[:image_attachment_content_type],
              attachment_file_name: inputs[:image_attachment_file_name],
              attachment_file_size: inputs[:image_attachment_file_size],
              business: inputs[:image_business],
              user: inputs[:image_user],
            },
          )
        elsif inputs[:id].present?
          super outputs
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
