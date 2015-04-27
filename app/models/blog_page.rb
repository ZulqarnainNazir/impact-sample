class BlogPage < Webpage
  store_accessor :settings, :per_page

  validates :per_page, presence: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 15 }

  before_validation do
    self.per_page = 10 unless per_page.present?
  end
end
