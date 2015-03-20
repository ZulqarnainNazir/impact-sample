class CustomPage < Page
  include PageCtaConcern
  include PageHeroConcern
  include PageSpecialtyConcern
  include PageTaglineConcern

  store_accessor :settings,
    :name

  validates :name, presence: true

  before_validation do
    self.name = title if !name.present? && title?
    self.pathname = title.parameterize if !pathname? && title?
  end
end
