desc 'Daily task that will to see which feeds are installed for each busienss'
task :check_feed_installations => :environment do

    #TODO - Content feed in web builder does not rely on Widget....not sure about listings either

    def check_site(site, prefix, uuid)

      response = HTTParty.get("#{site}")

      if response && response.code >= 200 && response.code < 400

        # Ex: directory-widget-uuid
        if response.include?("#{prefix}-#{uuid}")
          return true
        else
          return false
        end

      end
    end

    count = 0
    DirectoryWidget.all.each do |directory|

      event = Ahoy::Event.where_event("Reach", type_id: "#{directory.id}").last

      if event

        #if status is false or nil and event is current - set status to True
        if (directory.status == false || directory.status == nil) && event.time > Time.now - 3.days
          directory.status = true
          directory.save
          puts "New Widget Detected!"
        end

        #if status is true but not current - check site for installation and change status to false if not installed
        if directory.status == true && event.time < Time.now - 3.days
          if !check_site(event.properties["site"], "directory-widget", directory.uuid)
            directory.status = false
            directory.save
            puts "Unable to confirm installation. Status set to false."
          end

        end

        #If status is true and event is current - do nothing
        if directory.status == true && event.time > Time.now - 3.days
          puts "Nothing to see here"
        end

        #if status is false and not current - do nothing
        # if directory.status == false && event.time < Time.now - 3.days
        #   puts "Nothing installed"
        # end


      end

      count += 1

    end

    puts "#{count} directory widgets processed"
    puts "#{DirectoryWidget.all.size} directory widgets processed"


    # CalendarWidget.each do |calendar|
    #
    # end


    # ContentFeedWidget.each do |content|
    #
    # end

end
