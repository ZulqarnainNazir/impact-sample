class ReviewsBlock < Block
  before_validation do
    self.theme = 'default'
    self.style = 'default' unless style?
  end

  def cache_sensitive_key(params)
    if business
      business.customers.order(updated_at: :desc).pluck(:updated_at)[0]
    end
  end
end
