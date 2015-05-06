class SidebarFeedBlock < Block
  store_accessor :settings, :items_limit

  validates :items_limit, presence: true, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 15 }

  before_validation do
    self.items_limit = 4 unless items_limit.present?
    self.theme = 'default'
  end
end
