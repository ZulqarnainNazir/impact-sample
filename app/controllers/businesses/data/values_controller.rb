class Businesses::Data::ValuesController < Businesses::BaseController
  def update
    update_resource @business, values_params, context: :related_associations, location: [:edit, @business, :data_values]
  end

  private

  def values_params
    params.require(:business).permit(
      :values,
      :history,
      :vision,
      :community_involvement,
    )
  end
end
