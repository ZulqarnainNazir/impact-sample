class CallToActionBlock < Block
  before_validation do
    self.theme = 'default'
  end

  def cache_sensitive_key(params)
    frame.max_blocks
  end
end
