class Dashboard::DetailsController < Dashboard::BaseController
  before_action only: %i[create update] do
    params[:business][:category_ids].reject!(&:blank?) rescue nil
  end

  def update
    update_resource @business, business_params, location: @business
  end

  private

  def business_params
    params.require(:business).permit(
      :name,
      :description,
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
      owners: [current_user],
      logo_placement_attributes: {
        image_attributes: {
          user: current_user,
          business: @business,
        },
      },
    )
  end
end
