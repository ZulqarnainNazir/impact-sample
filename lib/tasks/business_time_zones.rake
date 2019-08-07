namespace :business_time_zones do
  task populate_zones: :environment do
    Business.all.each do |business|
      location = business.location
      if location && location.latitude && location.longitude
        business.time_zone = Timezone.lookup(location.latitude, location.longitude).to_s
        puts "Updating Business #{business.id} with time zone: #{business.time_zone}"
        business.save
      else
        if location
          location.multi_geocode
          location.save
          if location.latitude && location.longitude
            business.time_zone = Timezone.lookup(location.latitude, location.longitude).to_s
            puts "Updating Business #{business.id} with time zone: #{business.time_zone}"
            business.save
          else
            if business.event_definitions.any?
              puts "Uh oh, a business (#{business.id}) with events doesn't have a valid location to find a timezone with. This must be fixed."
            end
          end
        else
          if business.event_definitions.any?
            puts "Uh oh, a business (#{business.id}) with events doesn't have a valid location to find a timezone with. This must be fixed."
          end
        end
      end
    end
  end

  task convert_all_event_times_to_utc: :environment do
    imported_events_with_timezone = ImportedEventDefinition.joins(:event_feed).where.not(event_feeds: { time_zone: nil })
    imported_events_with_timezone.find_in_batches do |group|
      group.each do |event|
        event.time_zone = event.event_feed.time_zone
        puts "Recording timezone for imported event #{event.id} #{event.time_zone}"
        event.save
      end
    end
    events = EventDefinition.where.not(id: imported_events_with_timezone.ids).joins(:business).where.not(businesses: { time_zone: nil })
    events.find_in_batches do |group|
      group.each do |event_definition|
        end_time = event_definition.read_attribute(:end_time)
        if end_time == event_definition.legacy_end_time
          puts "updating end_time for #{event_definition.id}"
          event_definition.end_time = end_time
        else
          puts "already updated end_time for #{event_definition.id}"
        end
        start_time = event_definition.read_attribute(:start_time)
        if start_time == event_definition.legacy_start_time
          puts "updating start_time for #{event_definition.id}"
          
          event_definition.start_time = start_time
        else
          puts "already updated start_time for #{event_definition.id}"
        end
        raise event_definition.errors unless event_definition.save validate: false
      end
    end
  end
end
