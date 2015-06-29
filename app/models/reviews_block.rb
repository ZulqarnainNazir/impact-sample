class ReviewsBlock < Block
  before_validation do
    self.theme = 'default'
  end

  def cache_sensitive_key(params)
    if business
      business.reviews.order(updated_at: :desc).pluck(:updated_at)[0]
    end
  end
end
