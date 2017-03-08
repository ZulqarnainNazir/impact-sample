class Businesses::ActivityCalendarController < Businesses::BaseController
  def index
    events = MissionInstanceEvent.joins(mission_instance: :mission)
                                 .where(business: @business)
                                 .select(event_select_sql)

    instance_events = MissionInstance.joins(:mission)
                                     .where(business: @business)
                                     .where.not(start_date: nil, id: events.map(&:id))
                                     .active
                                     .one_time
                                     .select(instance_select_sql)
    history_events = MissionHistory
      .joins(mission_instance: :mission)
      .where(mission_instance_id: instance_events.map(&:id), action: 'completed')
      .select(history_select_sql)
      .each { |mh| mh.title = "#{mh.title} #{mh.action}" }

    @events = instance_events.concat(history_events).concat(events).each do |e|
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

  def instance_select_sql
    <<-SQL
      missions.id,
      mission_instances.start_date as start,
      mission_instances.start_date,
      mission_instances.start_time,
      mission_instances.business_id,
      missions.title
    SQL
  end

  def history_select_sql
    <<-SQL
      missions.id,
      mission_histories.created_at as start,
      mission_histories.action,
      mission_instances.business_id,
      missions.title
    SQL
  end

  def event_select_sql
    <<-SQL
      missions.id,
      mission_instance_events.occurs_on as start,
      mission_instance_events.business_id,
      mission_instance_events.occurs_on,
      mission_instance_events.mission_instance_id,
      mission_instances.start_date,
      mission_instances.start_time,
      missions.title
    SQL
  end
end
