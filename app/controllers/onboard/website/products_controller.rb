class Onboard::Website::ProductsController < Onboard::Website::BaseController
  include PlacementAttributesConcern

  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])

    unless @business.location && @business.website
      redirect_to [@business, :dashboard], alert: 'No Location or Website Found'
    end
  end

  def update
    update_resource @business, product_params, context: :onboard_website_continuation, location: [:edit_onboard_website, @business, :delivery]
  end

  private

  def product_params
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
      if safe_params[:line_attributes]
        safe_params[:lines_attributes].each do |_, attr|
          merge_placement_image_attributes_array attr[:line_images_attributes], :line_image_placement_attributes
        end
      end
    end
  end
end
