desc 'Daily task that will to see which feeds are installed for each busienss'
task :check_feed_installations => :environment do

    # For Each Widget Installed across all accounts
    # Lookup last event tracked in Ahoy::events by widget_id
    # If last tracked is > 3 days ago
    # ping site using url in event and see if a new event is created
    # if it is not, update status column on widget model to unverfiied/false
    # if it is, update status column on widget model to verfied/true

    #Make this a loop for all widgets
    #Also need to make sure this includes embeds in web builder

    # widget_id = ContentFeedWidget.find(48).id


    DirectoryWidget.all.each do |directory|

      event = Ahoy::Event.where_event("Reach", type_id: "#{directory.id}").last

      if event
        if event.time < Time.now - 3.days
          #ping page and recheck event
          response = HTTParty.get("#{event.properties["site"]}")

          if response.code >= 200 && response.code < 400
            event = Ahoy::Event.where_event("Reach", type_id: "#{directory.id}").last
            if event.time > Time.now - 3.days
              puts "#{directory.name}: Repinged & True"
              directory.status = true
              directory.save
            end
          else
            # puts "#{directory.name}: Repinged & False"
            directory.status = false
            directory.save
          end

        else
          # Update status column on widget model to false
          puts "#{directory.name}: True"
          directory.status = true
          directory.save
        end
      end
    end

    # CalendarWidget.each do |calendar|
    #
    # end
    #
    # ContentFeedWidget.each do |content|
    #
    # end

end
