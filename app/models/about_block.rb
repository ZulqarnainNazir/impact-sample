class AboutBlock < Block
  before_validation do
    self.theme = 'banner' unless theme?
  end
end
