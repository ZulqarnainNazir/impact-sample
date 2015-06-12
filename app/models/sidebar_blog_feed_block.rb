class SidebarBlogFeedBlock < Block
  validates :items_limit, presence: true, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 15 }

  before_validation do
    self.items_limit = 4 unless items_limit.present?
    self.theme = 'default'
  end

  def cache_sensitive_key(params)
    Time.at((Time.now.to_f / 5.minutes).floor * 5.minutes)
  end
end
