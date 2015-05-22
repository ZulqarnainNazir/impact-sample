class EventDefinitionSchedulerJob < ApplicationJob
  queue_as :default

  def perform(event_definition)
    event_definition.reschedule_events!
  end
end
