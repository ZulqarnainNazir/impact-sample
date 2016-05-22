class Businesses::DashboardsController < Businesses::BaseController
  before_action if: :user_signed_in? do
    unless current_user.authorized_businesses.any?
      redirect_to :new_onboard_website_business
    end
  end
end
