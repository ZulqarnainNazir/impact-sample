class Businesses::Data::DetailsController < Businesses::BaseController
  before_action only: %i[create update] do
    params[:business][:category_ids].reject!(&:blank?) rescue nil
  end

  def update
    update_resource @business, business_params, location: [:edit, @business, :data_details]
  end

  private

  def business_params
    params.require(:business).permit(
      :description,
      :kind,
      :name,
      :tagline,
      :website_url,
      :year_founded,
      category_ids: [],
      logo_placement_attributes: [
        :id,
        :_destroy,
        image_attributes: [
          :id,
          :alt,
          :title,
          :attachment_cache_url,
          :attachment_content_type,
          :attachment_file_name,
          :attachment_file_size,
          :_destroy,
        ],
      ],
    ).deep_merge(
      logo_placement_attributes: {
        image_attributes: {
          user: current_user,
          business: @business,
        },
      },
    )
  end
end
