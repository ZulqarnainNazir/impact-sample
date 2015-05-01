class Businesses::Data::DeliveriesController < Businesses::BaseController
  def update
    update_resource @business, deliveries_params, context: :related_associations, location: [:edit, @business, :data_delivery]
  end

  private

  def deliveries_params
    params.require(:business).permit(
      lines_attributes: [
        :id,
        :delivery_experience,
        :delivery_process,
      ],
    )
  end
end
