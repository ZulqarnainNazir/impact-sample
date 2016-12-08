class Businesses::Data::ContactsController < Businesses::BaseController
  def update
    update_resource @business, contacts_params, context: :related_associations, location: [:edit, @business, :data_contacts]
  end

  private

  def contacts_params
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
