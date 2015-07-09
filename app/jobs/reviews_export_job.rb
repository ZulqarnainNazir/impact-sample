class ReviewsExportJob < ApplicationJob
  queue_as :default

  def perform(business)
    # Nofify locable
  end
end
