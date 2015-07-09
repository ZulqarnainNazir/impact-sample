class EventsExportJob < ApplicationJob
  queue_as :default

  def perform(business)
    LocableEventsExport.export(business)
  end
end
