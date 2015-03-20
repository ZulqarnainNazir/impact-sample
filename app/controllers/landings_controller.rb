class LandingsController < ApplicationController
  before_action if: :user_signed_in? do
    if current_user.businesses.any?
      redirect_to :businesses
    else
      redirect_to :new_onboard_website_business
    end
  end
end
