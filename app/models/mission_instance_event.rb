class MissionInstanceEvent < ActiveRecord::Base
  belongs_to :business
  belongs_to :mission_instance

  attr_accessor :start

  enum status: [:incomplete, :completed, :skipped, :snoozed]

  scope :oldest, -> { order(occurs_on: :asc).incomplete }
  scope :next_due, -> { incomplete.where('occurs_on >= ?', Time.now) }
  scope :next_due_event, -> { incomplete.where('occurs_on >= ?', Time.now) }

  scope :occurs_on, -> (date) { where(occurs_on: date) }
  scope :for_today, -> { incomplete.where('occurs_on = ?', Time.zone.now) }
end
