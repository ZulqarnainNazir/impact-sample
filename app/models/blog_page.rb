class BlogPage < Webpage
  store_accessor :settings, :per_page

  validates :per_page, presence: true, numericality: { greater_than: 3, less_than: 21 }

  before_validation do
    self.per_page = 10 unless per_page.present?
  end
end
