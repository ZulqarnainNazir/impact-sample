class Businesses::DashboardsController < Businesses::BaseController
  before_action if: :user_signed_in? do
    unless current_user.authorized_businesses.any?
      redirect_to :new_onboard_website_business
    end
  end

  def show
    params[:future] ||= true unless params[:past]
    @events = ActivityCalendar.new(business: @business).timeline_events(nil, params[:future], params[:past]) #.limit(2)
    @event_count = @events.size
    @events = @events.limit(2)
    @mission_instances = @business.mission_instances
  end
end
