class CallToActionBlock < Block
  has_placed_image :call_to_action_block_image

  before_validation do
    self.theme = 'default'
  end

  def self.default_scope
    order(created_at: :asc)
  end
end
