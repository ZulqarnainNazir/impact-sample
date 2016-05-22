class LandingsController < ApplicationController
  before_action if: :user_signed_in? do
    if current_user.authorized_businesses.any?
      redirect_to :businesses
    else
      redirect_to :new_onboard_website_business
    end
  end

  def show
    render template: 'landings/show', layout: 'landing'
  end

end
