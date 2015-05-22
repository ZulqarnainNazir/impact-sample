class EventSchedule
  def initialize(start_date, start_time, end_date, end_time, repetition_days, repetition_weeks)
    @start_date = start_date.to_date
    @start_time = start_time.to_time
    @end_date = end_date.to_date
    @end_time = end_time.try(:to_time) || Time.now.end_of_day

    @repetition_days = Array(repetition_days).reject(&:blank?).map(&:to_i)
    @repetition_weeks = Array(repetition_weeks).reject(&:blank?).map(&:to_i).map { |n| n + 1 }

    @start_datetime = @start_date.to_datetime + @start_time.seconds_since_midnight.seconds
    @end_datetime = @end_date.to_datetime + @end_time.try(:seconds_since_midnight).to_i.seconds

    @schedule = IceCube::Schedule.new(@start_datetime)

    if @repetition_weeks.any? && @repetition_days.any?
      @schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_week @repetition_days.map { |day| { day => @repetition_weeks }}
    elsif @repetition_weeks.any?
      @schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_week({ (7 - @start_date.days_to_week_start) => @repetition_weeks })
    elsif @repetition_days.any?
      @schedule.add_recurrence_rule IceCube::Rule.weekly.day(*@repetition_days)
    end
  end

  def occurrences(end_datetime = @end_datetime)
    @schedule.occurrences(end_datetime)
  end
end
