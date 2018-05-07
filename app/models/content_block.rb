class ContentBlock < Block
  before_validation do
    self.theme = 'left' unless theme?
    self.style = 'transparent' unless style?
  end
end
