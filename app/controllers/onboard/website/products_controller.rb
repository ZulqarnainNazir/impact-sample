class Onboard::Website::ProductsController < Onboard::Website::BaseController
  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])

    unless @business.location && @business.website
      redirect_to [@business, :dashboard], alert: 'No Location or Website Found'
    end
  end

  def update
    update_resource @business, product_params, location: [:edit_onboard_website, @business, :delivery]
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
      ],
    )
  end
end
