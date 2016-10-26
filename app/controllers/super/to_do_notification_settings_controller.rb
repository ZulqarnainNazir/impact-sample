class Super::ToDoNotificationSettingsController < SuperController
  def index
    @businesses = Business.where(to_dos_enabled: true)
  end

  def create
    current_user.update(user_params)

    redirect_to :back, notice: "Updated subscriptions"
  end

  private

  def user_params
    params.require(:user).permit(following_business_ids: [])
  end
end
