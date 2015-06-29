desc 'Import reviews'
task import_reviews: [:environment] do
  Business.find_each do |business|
    ReviewsImportCce.import(business)
  end
end
