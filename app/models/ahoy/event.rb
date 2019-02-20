class Ahoy::Event < ActiveRecord::Base
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user

  # Needs to be moved to business.rb
  def self.get_reach(business_id)
    # Retireves the Reach number from the table

    # Business.find(business_id).reach

    reach = Ahoy::Event.update_aggregate_reach
    reach[business_id]

  end

  #move to business.rb
  def self.calc_estimated_reach(business_id)
    # Estimates the number of potenital impressions from following a business.
    # Get number of index loads in last 30 days
    loads = self.where('time > ?', Time.now - 30.days).where(name: "Reach").where_props(business_id: "#{business_id}").count

    # Return a range based on # of weekly posts - Currently hard coded to 2-4 posts per week and normalized for monthly
    # Future Update - Should base the range on average monthly posts for each busienss individually
    # Future Update - Should be smarter about posts types - ex: if they only have a calendar installed and the business doesnt post events then we should take that into account.
    if loads > 0
      return "#{(loads*2*52)/12}-#{(loads*4*52)/12}"
    else
      return "No Data Available"
    end
  end

  #move to business.rb
  def self.calc_visitors(business_id)
    # Calculates the number of people who have seen any content shown from an account. Unique Sessions NOT Unique users
    # Based on Ahoy::Visit ID in Ahoy::Event item

    self.where('time > ?', Time.now - 30.days).where(name: "Reach").where_props(business_id: "#{business_id}").pluck(:visit_id).uniq.count

  end

  # Run via scheduler once nightly
  def self.update_aggregate_reach
    # Calculates the number of times any content from an account is shown and updates business table. Widget Index Impressions + Content View Impressions and updates table

    aggregate_post_ids = []
    self.where('time > ?', Time.now - 30.days).where(name: "Reach").each do |event|
      if event.properties['posts']
        aggregate_post_ids << JSON.parse(event.properties['posts'])
      end
    end

    # Need to Add in view counts as well

    counts = aggregate_post_ids.flatten.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }

    counts.each do |k, v|
      b = Business.find(k)
      puts b.name
      # set reach column to v
      # b.reach = v
      # b.save
    end

    puts "Reach by Business:"
    return counts

  end

  # Run via scheduler once nightly
  #Probably she be a method in a differnt model or helper
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
