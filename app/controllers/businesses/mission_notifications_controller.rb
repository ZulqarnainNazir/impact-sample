class Businesses::MissionNotificationsController < Businesses::BaseController
  before_action only: :update do
    if params[:mission_notification_setting]
      if params[:mission_notification_setting][:summary_frequency] == 'null'
        params[:mission_notification_setting][:summary_frequency] = nil
      end

      if params[:mission_notification_setting][:suggestions_frequency] == 'null'
        params[:mission_notification_setting][:suggestions_frequency] = nil
      end
    end
  end

  def edit
    @notification_setting = MissionNotificationSetting.find_or_create_by(
      business: @business,
      user: current_user
    )
  end

  def update
    @notification_setting = @business.mission_notification_setting
    if @notification_setting.update(setting_params)
      redirect_to edit_business_mission_notifications_path(@business), notice: 'Settings updated'
    else
      render :edit, notice: 'Failed to update settings'
    end
  end

  private

  def setting_params
    params.require(:mission_notification_setting).permit(
      :weeky_due_notification,
      :daily_due_notification,
      :summary_notification,
      :suggestions_notification,
      :comment_notification,
      :suggestions_frequency,
      :summary_frequency,
      :daily_due_notification_preference,
      :weekly_due_notification_preference
    )
  end
end
