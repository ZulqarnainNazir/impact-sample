class FeedBlock < Block
  store_accessor :settings, :items_limit

  validates :items_limit, presence: true, numericality: { greater_than: 1, less_than: 21 }

  before_validation do
    self.items_limit = 3 unless items_limit.present?
    self.theme = 'default'
  end
end
