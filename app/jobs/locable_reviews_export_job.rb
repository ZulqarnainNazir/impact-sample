class LocableReviewsExportJob < ApplicationJob
  queue_as :default

  def perform(business)
    if business.automated_export_locable_reviews == '1'
      notify_locable '/reviews/import', impact_business_id: business.id
    end
  end
end
