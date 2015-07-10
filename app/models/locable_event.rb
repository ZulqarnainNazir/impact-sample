class LocableEvent < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'events'

  belongs_to :business, class_name: LocableBusiness.name, foreign_key: :business_id

  def import(impact_business)
    impact_business.event_definitions.where(
      external_type: 'locable',
      external_id: id,
    ).first_or_initialize.tap do |event_definition|
      event_definition.assign_attributes(
        description: description,
        end_date: end_date,
        end_time: end_time,
        price: price,
        repetition: repetition == 'Single' ? nil : schedule.to_s,
        start_date: start_date,
        start_time: start_time,
        subtitle: subtitle,
        title: name,
        url: url,
        event_definition_location_attributes: { location_id: impact_business.location.try(:id) },
      )
      event_definition.save
    end
  end

  private

  def schedule
    nil
  end

  def potential_schedule?
    IceCube::Schedule.new(start_at).tap do |s|
      weekdays = %i[sunday monday tuesday wednesday thursday friday saturday].select { |day| send(day) }
      weeknums = %i[week_1 week_2 week_3 week_4 week_5].select { |week| send(week) }.map { |week| week[-1].to_i }
      case repetition
      when 'Weekly'
        if weekdays.length == 7
          s.add_recurrence_rule IceCube::Rule.daily
        else
          weekdays.each do |day|
            s.add_recurrence_rule IceCube::Rule.weekly.day(day)
          end
        end
      when 'Monthly'
        if weeknums.last == 5 && weeknums.length == 5 || weeknums.length == 4
          if weekdays.length == 7
            s.add_recurrence_rule IceCube::Rule.daily
          else
            weekdays.each do |day|
              s.add_recurrence_rule IceCube::Rule.weekly.day(day)
            end
          end
        else
          weekdays.each do |day|
            s.add_recurrence_rule IceCube::Rule.monthly.day_of_week(day: weekdays)
          end
        end
      end
    end
  end
end
