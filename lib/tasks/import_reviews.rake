desc 'Import reviews'
task import_reviews: [:environment] do
  Business.where.not(cce_id: nil).find_each do |business|
    LocableReviewsImport.import(business)
  end
end
