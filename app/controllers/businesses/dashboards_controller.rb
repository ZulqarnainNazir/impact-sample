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

    @companies = @business.owned_companies.joins(:business).order("businesses.in_impact DESC").order("name ASC").includes(business: [:location]).limit(10)
    #ideally we add to query so that it shows companies with no networks then status = unclaimed then the rest. Do we need a scope for this?

    @reviews = @business.reviews.includes(:contact).order(reviewed_at: :desc).limit(3)

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
    # if ((community calendar || Directory || Job Board || Community Feed => website or widget) && (join Campaign || Post an Event || Share a Job || Quick Post) && (Profile Complete || Collected a Review || Website Customer)) || Business Creted > 180 Days || shown or hidden flag by user
    if ((( @business.quick_posts.count >= 1 || @business.jobs.count >= 1 || @business.events.count >= 1) && ( @business.reviews.count >= 1)) || @business.created_at < Date.today - 180.days)
      false
    else
      true
    end
    # true
  end

  def show_marketing_missions
    # Only show when quick start is hidden
    if show_quick_start
      false
    else
      true
    end
    # true
  end

  def show_local_connections
    # Only show if following a business > 1, followers is > 1

    if following_count >= 1 || follower_count >= 1
      true
    else
      false
    end
    # false
  end

  def show_campaigns
    # Only show after quick start is completed or if participating
    # if show_quick_start
    #   false
    # else
    #   true
    # end
    false
  end

  def show_community_content_feed
    # Only show when there are Followed By's
    if following_count >= 1
      true
    else
      false
    end
    false
  end

  def show_participation_status
    # Only show once there is a follower and hide if > 3 or 4 installed
    if follower_count >=1
      true
    else
      false
    end
    # false
  end

  def following_count
    companies = []
    @business.company_lists.each {|list| companies = companies.concat(list.companies)}
    companies.uniq.size
  end

  def follower_count
    @business.listed_by_business.length
  end




end
