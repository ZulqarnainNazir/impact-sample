#
# Takes an EventFeed, figures out which parser class relates the URL and uses
# the parser class to get an array of structs representng each event in the feed.
#
# For each of these, an ImportedEventDefinition is created.
#
# Usage:
#   Feeds::ImportService.new(event_feed: event_feed).run
#
# Command Line Usage:
# reload!; EventFeed.find(9).imported_event_definitions.destroy_all
# reload!; ef = EventFeed.find(9); Feeds::ImportService.new(event_feed: ef, always_notify: true).run
#
#
module Feeds
  class ImportError < StandardError; end

  class ImportService 
    attr_reader :event_feed, :parser, :stats, :always_notify

    def initialize(args = {})
      @event_feed     = args.fetch :event_feed
      @parser         = args.fetch :parser, parser_from_url
      @always_notify  = args.fetch :always_notify, true
      # These statistics are filled in as the service is run. This data is used
      # for notification emails about the feed later on.
      @stats = {
        total: 0,    # All event items found in the feed
        imported: 0, # Events that were imported
        invalid: 0,  # Events that were fully imported but missing data
        valid: 0,    # Events that were fully imported and valid (no missing data)
        failed: 0,   # Events which we failed to import due to an error
        matched: 0   # Feed events matched to previously imported events
      }
    end

    def run
      imported_events = parser.parse(event_feed)
      imported_events.map do |event|
        stats[:total] += 1

        create_event_definition(event) unless event_already_imported?(event)
      end

      send_notification if always_notify || anything_changed?
      event_feed.update_column(:last_imported, Time.now)

      stats
    end

    private

    def anything_changed?
      stats[:imported] > 0
    end

    def import_logger
      Logger.new(Rails.root.join('log/import_log.log'))
    end

    def event_already_imported?(event)
      existing_event = ImportedEventDefinition.find_by(imported_event_id: event.event_id.to_s, event_feed_id: event_feed.id).present?
      import_logger.info "found match for #{event.event_id}" if existing_event && Rails.env.development?
      stats[:matched] += 1 if existing_event
      existing_event
    end

    def create_event_definition(event)
      import_logger.info "importing #{event.event_id}" if Rails.env.development?
      # Only create a location if location information was found for the event.
      # We don't want a bunch of blank locations.
      if event.location_data_present?
        location = ::Location.where(
          business_id: event_feed.business_id,
          name: (event.location.try(:name) || ""),
          street1: event.location.try(:street1),
          street2: event.location.try(:street2),
          city: event.location.try(:city),
          state: event.location.try(:state),
          zip_code: event.location.try(:zip_code),
          phone_number: event.location.try(:phone_number),
          email: event.location.try(:email)
        ).first_or_initialize
      elsif event_feed.location.present?
        location = event_feed.location
      end
      picture_url  = event.try(:img).to_s
      picture_name = File.basename(URI.parse(picture_url).path).to_s
      event_definition = ImportedEventDefinition.new(
        business_id: event_feed.business_id,
        event_feed_id: event_feed.id,
        title: event.try(:title),
        subtitle: event.try(:subtitle),
        description: event.try(:summary),
        price: event.try(:price),
        url: event.try(:img),
        phone: event.try(:phone),
        start_date: event.try(:start_date),
        end_date: event.try(:end_date),
        start_time: event.try(:start_time),
        end_time: event.try(:end_time),
        imported_event_id: event.event_id.to_s,
        import_pending: false,
        published_status: true
      )

      begin
        EventDefinition.transaction do
          # Records should be created even with partial data that fail validations.
          # We want owners of the feed to have the opportunity to fill in the rest.
          image = open(picture_url)
          event_definition.event_image_placement_attributes = {
            image_alt: "event_image",
            image_title: "event_import",
            kind: "images",
            image_attachment_content_type: image.content_type,
            image_attachment_file_size: image.size,
            image_attachment_cache_url: picture_url,
            image_attachment_file_name: picture_name,
            image_user: User.find(event_feed.creator_id),
            image_business: event_feed.business,
          }
          event_definition.save validate: false
          location ||= ::Location.new(business_id: event_feed.business_id, name: '')
          location.save validate: false
          EventDefinitionLocation.create(
            event_definition: event_definition,
            location: location
          )
          event.try(:categories)&.each { |category| event_definition.content_categories.create(name: category, business_id: event_feed.business_id)}
          event_definition
        end
        stats[:imported] += 1
        # We use a custom set of validations for the imported event definition to
        # identify whether there is enough information to consider the event definition
        # fully "imported". We'll still create the event definition otherwise, but
        # it'll be created with a pending import status and not published.
        if event_definition.valid?(:feed_overview)
          event_definition.reschedule_events! # Create Event records
          event_definition.__elasticsearch__.index_document
          stats[:valid] += 1
        else
          event_definition.published_status = nil
          event_definition.import_pending = true
          event_definition.save validate: false
          stats[:invalid] += 1
        end
      rescue => ex
        Rails.logger.error "Event import failed with #{ex.message}"
        stats[:failed] += 1
      end
    end

    # Maps event feed URLs to parser classes. Whatever class is returned by this case
    # statement is used to parse the supplied Event Feed's URL and get the events from the feed.
    def parser_from_url
      case event_feed.url
      when  -> (event_feed_url) { known_webster_city_ical_event_hosts.any? { |host| event_feed_url.include? host }  }
        # Custom Parser for Webster City School District (rschooltoday) and Webster City Town Hall Calendar
        Feeds::Parsers::IcalWebsterCityParser.new
      when -> (event_feed_url) { event_feed_url.include? 'http://webstercityarea.chamberofcommerce.me/members/cal_xml/WCAC_rss.xml' }
        #Custom Parser for Webster City Chamber in Central timezone
        Feeds::Parsers::ChamberNationWebsterCityParser.new
      when  -> (event_feed_url) { known_chamber_master_event_hosts.any? { |host| event_feed_url.include? host }  }
        # Chamber Master uses RSS feeds
        Feeds::Parsers::ChamberMasterParser.new
      when  -> (event_feed_url) { known_chamber_nation_event_hosts.any? { |host| event_feed_url.include? host }  }
        # Chamber Nation & Chamber Organizer uses XML feeds - Only works for Pacific timezone feeds currently
        Feeds::Parsers::ChamberNationParser.new
      when /\.rss|\.xml/
        # Base RSS/XML Parser
        Feeds::Parsers::RssParser.new
      when /\.ics/
        # Base ICAL/ICS parser
        Feeds::Parsers::IcalParser.new
      when /time.ly/ && /xml/
        # TODO - Expand this check for mutliple version of timely calendars
        # when  -> (event_feed_url) { known_timely_event_hosts.any? { |host| event_feed_url.include? host } }
        # Base Timely Parser
        Feeds::Parsers::TimelyParser.new
      when /google\.com\/calendar\/v3/
        # Base Google Calendar Parser
        Feeds::Parsers::GoogleCalendarParser.new
      when /visitcharlevoix\.com\/\w*\.cfm$/
        Feeds::Parsers::VisitCharleVoixParser.new
      end
    end

    def known_webster_city_ical_event_hosts
      ['https://webstercity.com/', 'https://srv2-advancedview.rschooltoday.com/public/conference/ical/u/']
    end

    def known_chamber_master_event_hosts
      ['chambermaster.com', 'eldoradocounty.org', 'bataviachamber.org', 'chchamber.com']
    end

    def known_chamber_nation_event_hosts
      ['chamberofcommerce.me', 'chamberorganizer.com']
    end

    # def known_timely_event_hosts
    #   ['time.ly', 'timely', 'all-in-one-event-calendar']
    # end


    def no_new_info?
      stats[:total] == stats[:matched]
    end

    def send_notification
      authorizations = event_feed.business.authorizations.where(event_import_notifications: true)
      authorizations.each do |authorization|
        FeedMailer.import_finished(self, authorization.user, no_new_info?).deliver_now
      end
    end
  end
end
