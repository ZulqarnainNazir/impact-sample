class SidebarReviewsBlock < Block
  validates :items_limit, presence: true, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 15 }

  before_validation do
    self.items_limit = 4 unless items_limit.present?
    self.theme = 'default' unless theme?
  end

  def cache_sensitive_key(params)
    if business
      business.contacts.order(updated_at: :desc).pluck(:updated_at)[0]
    end
  end
end
