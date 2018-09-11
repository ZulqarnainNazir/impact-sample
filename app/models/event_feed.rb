class EventFeed < ActiveRecord::Base
  belongs_to :business
  # Creator isn't neccessarily a member of the associated business.
  # Users areable to create feeds for unclaimed businesses.
  belongs_to :creator, class_name: 'User'

  has_many :imported_event_definitions

  belongs_to :location
  accepts_nested_attributes_for :location, allow_destroy: true, reject_if: :all_blank

  validates :name, :url, presence: true
  validate :uniq_url, :ensure_parsable

  after_save :import

  def import(always_notify = true)
    FeedImportJob.perform_later id, always_notify
  end

  def import_service
    Feeds::ImportService.new(event_feed: self)
  end

  def events_in_feed
    import_service.parser.parse(url)
  end

  def self.for_business(business)
    EventFeed.where('business_id IN (?)', business.owned_businesses.select{ |b| !b.in_impact }.map(&:id) + [business.id])
  end

  private

  def ensure_parsable
    unless import_service.parser.present?
      errors.add(:url, "Uh-oh, we're unable to parse this feed URL")
    end
  end

  def uniq_url
    uri = URI.parse(url)
    host = uri.host ? uri.host.sub('www.', '') : ''
    path = uri.path
    feed = EventFeed.where.not(id: id).where("url LIKE ?", "%#{host}#{path}%").first
    if feed
      errors.add(:url, "Uh-oh, that feed has already been added to #{feed.business.name}, you can add them to a Local Network to include their events in a calendar. If you think this is a mistake and you own this feed, please contact us.")
    end
  end
end
