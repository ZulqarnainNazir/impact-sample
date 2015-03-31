module PlacedImageConcern
  extend ActiveSupport::Concern

  class_methods do
    def has_placed_image(association_name)
      placement_name = "#{association_name}_placement".to_sym

      has_one placement_name, -> { where(context: association_name) }, as: :placer, class_name: Placement.name, dependent: :destroy
      has_one association_name, through: placement_name, source: :image

      rejection_proc = proc do |attributes|
        attributes.all? do |k, v|
          k == '_destroy' || k == 'placer' || k == 'context' || v.blank? ||
            (k == 'image_attributes' && v.all? { |k, v| k == '_destroy' || k == 'business' || k == 'user' || v.blank? })
        end
      end

      accepts_nested_attributes_for placement_name, allow_destroy: true, reject_if: rejection_proc

      define_method "#{placement_name}_attributes=" do |attributes = {}|
        super attributes.merge(placer: self, context: association_name)
      end

      define_method "#{association_name}_url" do |*args|
        placement = send(placement_name)
        placement.send(:attachment_url, *args) if placement
      end
    end
  end
end
