class ActivityCalendar
  PAGES_PER = 10
  attr_reader :business

  def initialize(args = {})
    @business = args[:business]
  end

  def timeline_events(page = 0, future = false, past = false)
    events = calendar_events(future, past)
    events = future ? events.sort_by(&:start) : events.sort_by(&:start).reverse

    Kaminari.paginate_array(events)
            .page(page)
            .per(PAGES_PER)
  end

  def calendar_events(future = false, past = false)
    historical_events.each { |mh| mh.title = "#{mh.title} #{mh.action}" }

    events = if future
      events_by_date(direction: '>', date: Time.now)
    elsif past
      events_by_date(direction: '<', date: Time.now)
    else
      all_events
    end

    events.each do |e|
      if e.is_a?(MissionInstance) && e.start_date && e.start_time
        e.start = e.schedule_starts_at.in_time_zone(Time.zone)
      elsif e.is_a?(MissionInstance)
        e.start = e.start_date.in_time_zone(Time.zone)
      elsif e.is_a?(MissionInstanceEvent) && e.start_time
        e.start = (e.occurs_on.to_time + e.start_time.seconds_since_midnight.seconds).in_time_zone(Time.zone)
      elsif e.is_a?(MissionInstanceEvent)
        e.start = e.occurs_on.in_time_zone(Time.zone)
      else
        e.start = e.start.in_time_zone(Time.zone)
      end
    end.each do |event|
      if event.start == event.start.beginning_of_day
        event.start = event.start.to_date
      end
    end.uniq { |event| "#{event.class}#{event.id}#{event.start}" }
  end

  private

  def all_events
    recurring_events.concat(one_time_events).concat(historical_events)
  end

  def events_by_date(args)
    recurring_events(args)
      .concat(one_time_events(args))
      .concat(historical_events(args))
  end

  def filter_by_date(relation, args)
    direction = args[:direction]
    date      = args[:date]
    column    = args[:column]

    if direction && date && column
      relation.where("#{column} #{direction} ?", date)
    else
      relation
    end
  end

  def recurring_events(args = {})
    begin
      select_sql = <<-SQL
        missions.id,
        mission_instance_events.occurs_on AS start,
        mission_instance_events.business_id,
        mission_instance_events.occurs_on,
        mission_instance_events.mission_instance_id,
        mission_instances.start_date,
        mission_instances.start_time,
        missions.description,
        missions.title
      SQL

      events = MissionInstanceEvent
        .joins(mission_instance: :mission)
        .where(business: business)

      args.merge!(column: 'occurs_on')

      events = filter_by_date(events, args)
      events.select(select_sql)
    end
  end

  def one_time_events(args = {})
    begin
      select_sql = <<-SQL
        missions.id,
        mission_instances.id AS mission_instance_id,
        mission_instances.start_date AS start,
        mission_instances.start_date,
        mission_instances.start_time,
        mission_instances.business_id,
        missions.description,
        missions.title
      SQL

      events = MissionInstance
        .joins(:mission)
        .where(business: business)
        .where.not(start_date: nil, id: recurring_events.map(&:id))
        .active
        .one_time

      args.merge!(column: 'start_date')

      events = filter_by_date(events, args)
      events.select(select_sql)
    end
  end

  def historical_events(args = {})
    begin
      select_sql = <<-SQL
        missions.id,
        mission_histories.created_at AS start,
        mission_histories.action,
        mission_histories.action AS description,
        mission_histories.mission_instance_id,
        mission_instances.business_id,
        missions.title
      SQL

      events = MissionHistory
        .joins(mission_instance: :mission)
        .where(mission_instance_id: one_time_events.map(&:id), action: 'completed')

      args.merge!(column: 'mission_histories.created_at')

      events = filter_by_date(events, args)
      events.select(select_sql)
    end
  end
end
