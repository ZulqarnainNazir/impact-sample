desc 'Daily task that will to see which feeds are installed for each busienss'
task :check_feed_installations => :environment do

    #Listings do not count as an installation, only widgets and website embeds

    #TODO - Content feed in web builder does not rely on Widget, must be updated in order to be tracked this way

    def check_site(site, prefix, uuid)
      #Status check keys off of url from last Ahoy::Event and checks for presence of ID (prefix + uuid) on the page. If ID isn't present in view then we will not be able to confirm installation.

      response = HTTParty.get("#{site}")

      if response && response.code >= 200 && response.code < 400

        # Ex: directory-widget-uuid
        if response.include?("#{prefix}#{uuid}")
          return true
        else
          return false
        end

      end
    end

    DirectoryWidget.all.each do |directory|

      event = Ahoy::Event.where_event("Reach", type_id: "#{directory.id}").last

      if event

        #if status is false or nil and event is current - set status to True
        if (directory.status == false || directory.status == nil) && event.time > Time.now - 3.days
          directory.status = true
          # puts "New Widget Detected!"
          # puts directory.id
        end

        #if status is true but not current - check site for installation and change status to false if not installed
        if directory.status == true && event.time < Time.now - 3.days
          if !check_site(event.properties["site"], "directory-widget-", directory.uuid)
            directory.status = false
            # puts "Unable to confirm installation. Status set to false."
            # puts directory.id
          end

        end

        #If status is true and event is current - do nothing
        # if directory.status == true && event.time > Time.now - 3.days
        #   puts "Nothing to see here"
        #   puts directory.id
        # end

        #if status is false and not current - do nothing
        # if directory.status == false && event.time < Time.now - 3.days
        #   puts "Nothing installed"
        # end
      end

      directory.save
    end

    puts "#{DirectoryWidget.all.size} directory widgets processed."


    CalendarWidget.all.each do |calendar|

      event = Ahoy::Event.where_event("Reach", type_id: "#{calendar.id}").last

      if event

        #if status is false or nil and event is current - set status to True
        if (calendar.status == false || calendar.status == nil) && event.time > Time.now - 3.days
          calendar.status = true
          # puts "New Widget Detected!"
          # puts calendar.id
        end

        #if status is true but not current - check site for installation and change status to false if not installed
        if calendar.status == true && event.time < Time.now - 3.days
          if !check_site(event.properties["site"], "calendar-widget-", calendar.uuid)
            calendar.status = false
            # puts "Unable to confirm installation. Status set to false."
            # puts calendar.id
          end

        end

        #If status is true and event is current - do nothing
        # if calendar.status == true && event.time > Time.now - 3.days
        #   puts "Nothing to see here"
        #   puts calendar.id
        # end

        #if status is false and not current - do nothing
        # if calendar.status == false && event.time < Time.now - 3.days
        #   puts "Nothing installed"
        # end
      end

      calendar.save
    end

    puts "#{CalendarWidget.all.size} calendar widgets processed."


    ContentFeedWidget.all.each do |content_feed|

      event = Ahoy::Event.where_event("Reach", type_id: "#{content_feed.id}").last

      if event

        #if status is false or nil and event is current - set status to True
        if (content_feed.status == false || content_feed.status == nil) && event.time > Time.now - 3.days
          content_feed.status = true
          # puts "New Widget Detected!"
          # puts content_feed.id
        end

        #if status is true but not current - check site for installation and change status to false if not installed
        if content_feed.status == true && event.time < Time.now - 3.days
          if !check_site(event.properties["site"], "content-feed-widget-", content_feed.uuid)
            content_feed.status = false
            # puts "Unable to confirm installation. Status set to false."
            # puts content_feed.id
          end

        end

        #If status is true and event is current - do nothing
        # if content_feed.status == true && event.time > Time.now - 3.days
        #   puts "Nothing to see here"
        #   puts content_feed.id
        # end

        #if status is false and not current - do nothing
        # if content_feed.status == false && event.time < Time.now - 3.days
        #   puts "Nothing installed"
        # end
      end

      content_feed.save
    end

    puts "#{ContentFeedWidget.all.size} content feed widgets processed."

end
