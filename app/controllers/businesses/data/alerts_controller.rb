class Businesses::Data::AlertsController < Businesses::BaseController
  before_action do
    @alert = @business.alert || @business.build_alert
  end

  def update

    update_resource @alert, alert_params, location: [:edit, @business, :data_alert]
    # do |success|
    #   if success
    #     @alert.event_definitions.each(&:touch)
    #   end
    # end
  end

  private

  def alert_params
    params.require(:alert).permit(
      :alert_type,
      :message,
    )
  end
end
