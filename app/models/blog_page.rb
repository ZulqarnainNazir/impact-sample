class BlogPage < Webpage
  store_accessor :settings, :per_page, :width

  validates :per_page, presence: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 15 }

  before_validation do
    self.per_page = 10 unless per_page.present?
  end

  def blocks_count
    0
  end

  def width
    super == 'full' ? 'full' : 'sidebar'
  end
end
