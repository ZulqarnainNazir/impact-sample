class ContactBlock < Block
  before_validation do
    self.theme = 'right' unless theme?
  end

  def location
    business.try(:location).try(:as_json, methods: %i[address_line_one address_line_two])
  end

  def openings
    if business.try(:location)
      business.location.openings.as_json(methods: %i[days hours])
    else []
    end
  end

  def cache_sensitive_key(params)
    [business, business.try(:location)].compact.map(&:cache_key).join('-')
  end
end
