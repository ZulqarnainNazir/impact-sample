class ContactBlock < Block
  before_validation do
    self.theme = 'right' unless theme?
  end

  def openings
    business.try(:location).try(:openings)
  end
end
