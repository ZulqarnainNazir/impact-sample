class Businesses::DashboardsController < Businesses::BaseController
  before_action if: :user_signed_in? do
    unless current_user.authorized_businesses.any?
      redirect_to :new_onboard_website_business
    end
  end

  def show
    metadata = {:company_name => @business.name, :company_id => @business.id}
    flash[:appcues_event] = "Appcues.track('dashboard for #{@business.name} visited by #{current_user.name}')"
    intercom_event("dashboard-visited", metadata)

    params[:future] ||= true unless params[:past]
    @events = ActivityCalendar.new(business: @business).timeline_events(nil, params[:future], params[:past]) #.limit(2)
    @event_count = @events.size
    @events = @events.limit(2)
    @mission_instances = @business.mission_instances
    @show_quick_start = self.show_quick_start
    @show_marketing_missions = self.show_marketing_missions
    @show_local_connections = self.show_local_connections
    @show_campaigns = self.show_campaigns
    @show_community_content_feed = self.show_community_content_feed
    @show_participation_status = self.show_participation_status
  end

  protected


  def show_quick_start
    # Only show for a short amount of time like x # of things completed then default to missions
    false
  end

  def show_marketing_missions
    # Only show when quick start is hidden
    true
  end

  def show_local_connections
    # Only show if following a business > 1, followers is > 1 or if local networks is > than default (1)
    true
  end

  def show_campaigns
    # Only show after quick start is completed
    false
  end

  def show_community_content_feed
    # Only show when there are Followed By's
    true
  end

  def show_participation_status
    # Only show once there is a follower and hide if > 3 or 4 installed
    false
  end




end
