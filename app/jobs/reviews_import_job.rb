class ReviewsImportJob < ApplicationJob
  queue_as :default

  def perform(business)
    ReviewsImportCce.import(business)
  end
end
