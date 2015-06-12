class ContactBlock < Block
  before_validation do
    self.theme = 'right' unless theme?
  end

  def openings
    if business.try(:location)
      business.location.openings.as_json(methods: %i[days hours])
    else []
    end
  end
end
