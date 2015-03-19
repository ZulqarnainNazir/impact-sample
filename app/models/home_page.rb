class HomePage < Page
  include PageCtaConcern
  include PageHeroConcern
  #include PageLayoutConcern
  #include PageReviewsConcern
  include PageSpecialtyConcern
  include PageTaglineConcern

  def name
    'Homepage'
  end
end
