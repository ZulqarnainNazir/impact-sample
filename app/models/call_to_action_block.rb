class CallToActionBlock < Block
  has_placed_image :call_to_action_block_image

  before_validation do
    self.theme = 'default'
  end
end
