class ContactPage < Page
  store_accessor :settings,
    :contact_theme,
    :text

  validates :contact_theme, presence: true, inclusion: { in: %w[right banner inline] }

  def name
    'Contact'
  end
end
