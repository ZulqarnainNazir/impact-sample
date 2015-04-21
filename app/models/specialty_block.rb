class SpecialtyBlock < Block
  has_placed_image :specialty_block_image

  before_validation do
    self.theme = 'left' unless theme?
  end
end
