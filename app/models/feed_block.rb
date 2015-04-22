class FeedBlock < Block
  store_accessor :settings, :items_limit

  before_validation do
    self.theme = 'default'
  end

  def items_limit
    super.to_i > 0 ? super.to_i : 10
  end
end
