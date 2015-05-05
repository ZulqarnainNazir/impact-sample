class Businesses::Data::LinesController < Businesses::BaseController
  include PlacementAttributesConcern

  def update
    update_resource @business, lines_params, context: :related_associations, location: [:edit, @business, :data_lines]
  end

  private

  def lines_params
    params.require(:business).permit(
      lines_attributes: [
        :id,
        :type,
        :title,
        :description,
        :_destroy,
        line_images_attributes: [
          :id,
          :_destroy,
          line_image_placement_attributes: placement_attributes,
        ],
      ],
    ).tap do |safe_params|
      if safe_params[:lines_attributes]
        safe_params[:lines_attributes].each do |_, attr|
          merge_placement_image_attributes_array attr[:line_images_attributes], :line_image_placement_attributes
        end
      end
    end
  end
end
