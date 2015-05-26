class EventDefinitionLocation < ActiveRecord::Base
  belongs_to :event_definition
  belongs_to :location

  validates :event_definition, presence: true
  validates :location, presence: true
end
