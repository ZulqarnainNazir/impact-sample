class EventsExportJob < ApplicationJob
  queue_as :default

  def perform(business)
    if business.automated_export_locable_events == '1'
      notify_locable '/events/import', impact_business_id: business.id
    end
  end
end
