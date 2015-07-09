class ReviewsImportJob < ApplicationJob
  queue_as :default

  def perform(business)
    LocableReviewsImport.import(business)
  end
end
