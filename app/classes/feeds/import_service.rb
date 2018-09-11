#
# Takes a feed URL, downloads the response and delegates it to a parser class.
# The parser class is expected to return a collection of Feed::Events from which
# imported events can be created.
#
# Usage:
#   Feeds::ImportService.new(event_feed: event_feed).run
#
module Feeds
  class ImportError < StandardError; end

  class ImportService
    attr_reader :event_feed, :parser, :stats, :always_notify

    def initialize(args = {})
      @event_feed    = args.fetch :event_feed
      @parser        = args.fetch :parser, parser_from_url
      @always_notify = args.fetch :always_notify, true

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
      imported_events = parser.parse(event_feed.url)
      imported_events.map do |event|
        stats[:total] += 1

        create_event_definition(event) unless event_already_imported?(event)
      end

      send_notification if always_notify || anything_changed?
      event_feed.update_column(:last_imported, Time.now)
      # event_feed.imported_event_definitions.import
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

      event_definition = ImportedEventDefinition.new(
        business_id: event_feed.business_id,
        event_feed_id: event_feed.id,
        title: event.try(:title),
        subtitle: event.try(:subtitle),
        description: event.try(:summary),
        price: event.try(:price),
        url: event.try(:url),
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
          event_definition.save validate: false
          location ||= ::Location.new(business_id: event_feed.business_id, name: '')
          location.save validate: false
          EventDefinitionLocation.create(
            event_definition: event_definition,
            location: location
          )
          event_definition
        end
        stats[:imported] += 1
        if event_definition.valid?(:feed_overview)
          event_definition.reschedule_events!
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

    def parser_from_url
      case event_feed.url
      when /.*chambermaster|chamberorganizer/
        Feeds::Parsers::ChamberMasterParser.new
      when /\.rss|\.xml/
        Feeds::Parsers::RssParser.new
      when /\.ics/
        Feeds::Parsers::IcalParser.new
      when /time.ly/ && /xml/
        Feeds::Parsers::TimelyParser.new
      when /google\.com\/calendar\/v3/
        Feeds::Parsers::JsonParser.new
      end
    end

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