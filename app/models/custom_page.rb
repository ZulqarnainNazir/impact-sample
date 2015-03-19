class CustomPage < Page
  include PageCtaConcern
  include PageHeroConcern
  include PageSpecialtyConcern
  include PageTaglineConcern

  store_accessor :settings,
    :name

  validates :name, presence: true
end
