class Businesses::NotificationSettingsController < Businesses::BaseController
  def index
    @setting = ToDoNotificationSetting.find_or_create_by(
      business: @business,
      user: current_user
    )
  end

  def update
    @setting = current_user.to_do_notification_settings.find(params[:id])

    if @setting.update(settings_params)
      redirect_to business_to_dos_path(@business)
    else
      render :index
    end
  end

  private

  def settings_params
    params.require(:to_do_notification_setting).permit(
      :assigned,
      :updates_or_comments,
      :deadline_approaching,
      :due,
      :overdue_reminder_interval,
      :accepted
    )
  end
end
