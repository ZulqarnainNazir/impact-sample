class SpecialtyBlock < Block
  before_validation do
    self.theme = 'left' unless theme?
  end
end
