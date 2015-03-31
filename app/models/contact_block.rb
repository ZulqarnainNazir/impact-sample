class ContactBlock < Block
  before_validation do
    self.theme = 'right' unless theme?
  end
end
