class Ahoy::Event < ActiveRecord::Base
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user

  # Run via scheduler once nightly
  #Probably she be a method in a differnt model or helper or rake
  def self.check_widget_installations

    # For Each Widget Installed across all accounts
    # Lookup last event tracked in Ahoy::events by widget_id
    # If last tracked is > 3 days ago
    # ping site using url in event and see if a new event is created
    # if it is not, update status column on widget model to unverfiied/false
    # if it is, update status column on widget model to verfied/true

    #Make this a loop for all widgets
    #Also need to make sure this includes embeds in web builder
    widget_id = ContentFeedWidget.find(48).id

    event = self.where_event("Reach", widget_id: "#{widget_id}").last

    # return event.time

    if event.time < Time.now - 3.days
      #ping page and recheck event
      #update status column on widget model to true
      return true
    else
      # Update status column on widget model to false
      return false
    end

    # self.where('time > ?', Time.now - 3.days).where(name: "Reach").each do |event|
    #   if event.properties['posts']
    #     aggregate_post_ids << JSON.parse(event.properties['posts'])
    #   end
    # end

  end



end
