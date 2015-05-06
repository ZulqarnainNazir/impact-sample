class SidebarContentBlock < Block
  has_placed_image :sidebar_content_block_image

  before_validation do
    self.theme = 'default'
  end
end
