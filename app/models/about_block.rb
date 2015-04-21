class AboutBlock < Block
  has_placed_image :about_block_image

  before_validation do
    self.theme = 'banner' unless theme?
  end
end
