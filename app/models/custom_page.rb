class CustomPage < Page
  store_accessor :settings,
    :name

  validates :name, presence: true
end
