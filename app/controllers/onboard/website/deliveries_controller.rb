class Onboard::Website::DeliveriesController < Onboard::Website::BaseController
  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])

    unless @business.location && @business.website
      redirect_to [@business, :dashboard], alert: 'No Location or Website Found'
    end

    unless @business.lines.any?
      redirect_to [:edit_onboard_website, @business, :values]
    end
  end

  def update
    update_resource @business, delivery_params, context: :related_associations, location: [:edit_onboard_website, @business, :customers]
  end

  private

  def delivery_params
    params.require(:business).permit(
      lines_attributes: [
        :id,
        :delivery_experience,
        :delivery_process,
      ],
    )
  end
end
