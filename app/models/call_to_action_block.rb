class CallToActionBlock < Block
  has_placed_image :call_to_action_block_image

  before_validation do
    self.theme = 'default'
    self.call_to_action_block_image_placement_attributes = image_accessor_attributes if image_accessors?
  end

  def self.default_scope
    order(created_at: :asc)
  end

  def react_attributes
    super(call_to_action_block_image, call_to_action_block_image_placement)
  end
end
