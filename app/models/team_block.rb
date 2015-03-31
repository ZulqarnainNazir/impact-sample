class TeamBlock < Block
  before_validation do
    self.theme = 'vertical' unless theme?
  end
end
