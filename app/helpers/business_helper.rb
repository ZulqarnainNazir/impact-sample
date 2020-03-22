module BusinessHelper
  def alert_message(value)
    case value
    when 'normal_operations'
      "We're Open!"
    when 'modified_operations'
      "We're open but with new hours/limited operations!"
    when 'temporarily_closed'
      "We're temporarily closed, but we'll be back!"
    end
  end
end
