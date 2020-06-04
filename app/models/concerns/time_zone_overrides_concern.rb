module TimeZoneOverridesConcern
  extend ActiveSupport::Concern

  def associated_time_zone
    if type == 'ImportedEventDefinition'
      event_feed&.time_zone || business&.time_zone || Time.zone
    else
      business&.time_zone || Time.zone
    end
  end

  def start_time(force_time_zone = nil)
    return unless read_attribute(:start_time).present?
    before_zone = Time.zone
    zone = force_time_zone || associated_time_zone
    Time.zone = zone
    date = start_date || end_date || Date.today
    build_date_time_with_zone(date, read_attribute(:start_time), zone)
  ensure
    Time.zone = before_zone
  end

  def end_time(force_time_zone = nil)
    return unless read_attribute(:end_time).present?
    before_zone = Time.zone
    zone = force_time_zone || associated_time_zone
    Time.zone = zone
    date = end_date || start_date || Date.today
    build_date_time_with_zone(date, read_attribute(:end_time), zone)
  ensure
    Time.zone = before_zone
  end

  def start_time=(value)
    return unless value.present?
    value = value.to_s
    before_zone = Time.zone
    Time.zone = associated_time_zone
    self.time_zone = associated_time_zone
    date = start_date || end_date || Date.today
    offset = date.in_time_zone(associated_time_zone).formatted_offset
    datetime = build_date_time_with_zone(date, Time.parse(value), associated_time_zone, offset)
    write_attribute :start_time, datetime.utc
  ensure
    Time.zone = before_zone
  end

  def end_time=(value)
    return unless value.present?
    value = value.to_s
    before_zone = Time.zone
    Time.zone = associated_time_zone
    self.time_zone = associated_time_zone
    date = end_date || start_date || Date.today
    offset = date.in_time_zone(associated_time_zone).formatted_offset
    datetime = build_date_time_with_zone(date, Time.parse(value), associated_time_zone, offset)
    write_attribute :end_time, datetime.utc
  ensure
    Time.zone = before_zone
  end

  def build_date_time_with_zone(date, time, zone, offset = nil)
    date = time.to_date if time.to_date > date
    datetime = DateTime.new(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.min
    )
    if offset
      datetime.change(offset: offset)
    else
      datetime.in_time_zone(zone)
    end
  end
end
