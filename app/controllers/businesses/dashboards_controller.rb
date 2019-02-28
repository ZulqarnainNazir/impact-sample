class Businesses::DashboardsController < Businesses::BaseController
  before_action if: :user_signed_in? do
    unless current_user.authorized_businesses.any?
      redirect_to :new_onboard_website_business
    end
  end

  def show
    metadata = {:company_name => @business.name, :company_id => @business.id}
    # flash[:appcues_event] = "Appcues.track('dashboard for #{@business.name} visited by #{current_user.name}')"
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

    # TODO - Add Join Campaign Option replacing offer or job/volunteer opportunity
    # TODO - Add || shown or hidden flag by user to end of if
    # TODO - Update field when Read Playbook is clicked to mark as complete/grayed out (but dont count it as a check below)?
    # TODO - Replace content feed that has jobs with Job Board widget when available
    # TODO - Lessen website TODO requirement but add check that site is live

    # TODO - Add Profile Complete Check to foundation group

    #Simply to break up the logic into more readable chunks
    foundation_group = [@business.percent_profile_completeness == 100, @business.reviews.count >= 1, ((!@business.is_on_engage_plan? || !@business.build_plan_no_setup_fee == true) && @business.to_dos.where(status: 0).count == 0)].count(true) >= 2
    particpation_group = [@business.support_local_directory_installed, @business.community_calendar_installed, @business.community_content_feed_installed, @business.community_content_feed_installed_with_jobs].count(true) >= 2
    conversation_group = [@business.quick_posts.count >= 1,  @business.jobs.count >= 1, @business.offers.count >= 1,  @business.events.count >= 1].count(true) >= 3

    # puts "Foundation: #{foundation_group}"
    # puts "Participation: #{particpation_group}"
    # puts "Conversation: #{conversation_group}"
    # puts "Created at: #{@business.created_at < Date.today - 180.days}"

    if (foundation_group && particpation_group && conversation_group) || @business.created_at < Date.today - 180.days
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
    true
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
    #Need to add installation checks
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
