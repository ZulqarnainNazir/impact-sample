class DatepickerParser
  def self.parse(value)
    if value.to_s.split('/').length == 3
      values = value.split('/')
      values = values[-1..-1] + values[0..-2]
      Date.parse(values.join('/'))
    else
      value
    end
  end
end
