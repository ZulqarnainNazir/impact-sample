desc 'Set BeforeAfter, Gallery, Offer, QuickPost published_on to the created_at value'
task migrate_post_dates: [:environment] do
  BeforeAfter.find_each do |record|
    record.update published_on: record.created_at
  end

  Gallery.find_each do |record|
    record.update published_on: record.created_at
  end

  Offer.find_each do |record|
    record.update published_on: record.created_at
  end

  QuickPost.find_each do |record|
    record.update published_on: record.created_at
  end
end
