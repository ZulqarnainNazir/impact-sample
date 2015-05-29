class Event < ActiveRecord::Base
  belongs_to :business
  belongs_to :event_definition

  validates :business, presence: true
  validates :event_definition, presence: true
  validates :occurs_on, presence: true

  def to_param
    "#{id}-#{event_definition.title}".parameterize
  end
end
