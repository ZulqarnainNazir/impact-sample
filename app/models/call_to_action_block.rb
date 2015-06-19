class CallToActionBlock < Block
  before_validation do
    self.theme = 'default'
  end

  def cache_sensitive_key(params)
    group.max_blocks
  end
end
