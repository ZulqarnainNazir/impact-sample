class EventsImportJob < ApplicationJob
  queue_as :default

  def perform(business)
    LocableEventsImport.import(business)
  end
end
