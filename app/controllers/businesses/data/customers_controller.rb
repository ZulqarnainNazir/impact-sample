class Businesses::Data::CustomersController < Businesses::BaseController
  def update
    update_resource @business, customers_params, context: :related_associations, location: [:edit, @business, :data_customers]
  end

  private

  def customers_params
    params.require(:business).permit(
      lines_attributes: [
        :id,
        :customer_description,
        :customer_problem,
        :customer_benefit,
        :uniqueness,
      ],
    )
  end
end
