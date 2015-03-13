class WebsiteOnboard::BusinessesController < WebsiteOnboard::BaseController
  before_action only: new_actions do
    @business = Business.new
  end

  before_action only: member_actions do
    @business = current_user.businesses.find(params[:id])
  end

  before_action only: %i[create update] do
    params[:business][:category_ids].reject!(&:blank?) rescue nil
  end

  def create
    create_resource @business, business_params, location: [:edit_website_onboard, @business, :location]
  end

  def update
    update_resource @business, business_params, location: [:edit_website_onboard, @business, :location]
  end

  def destroy
    @business.destroy!
    redirect_to :new_website_onboard_business, notice: 'Ok, we’ve removed your business.'
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
