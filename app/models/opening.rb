class Opening < ActiveRecord::Base
  belongs_to :location, touch: true

  def days_and_hours
    { id: id, days: days, hours: hours }
  end

  def days
    list = []
    list.push 'Sun' if sunday?
    list.push 'Mon' if monday?
    list.push 'Tue' if tuesday?
    list.push 'Wed' if wednesday?
    list.push 'Thu' if thursday?
    list.push 'Fri' if friday?
    list.push 'Sat' if saturday?
    list.join(', ')
  end

  def hours
    [opens_at, closes_at].reject(&:blank?).map { |time| time.strftime('%l:%M%P') }.join('-')
  end
end
