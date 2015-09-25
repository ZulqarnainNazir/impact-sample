class LocableReviewsImportJob < ApplicationJob
  queue_as :default

  def perform(business)
    LocableReviewsImport.import(business)
  end
end
