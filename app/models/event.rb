class Event < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ExternalUrlHelper
  include Rails.application.routes.url_helpers

  belongs_to :business
  belongs_to :event_definition

  validates :business, presence: true
  validates :event_definition, presence: true
  validates :occurs_on, presence: true

  if ENV['REDUCE_ELASTICSEARCH_REPLICAS'].present?
    settings index: { number_of_shards: 1, number_of_replicas: 0 }
  end

  def occurs_on_with_time_timestamp
    if event_definition&.start_time
      occurs_on.strftime('%b %d, %Y') + ' at ' + event_definition.start_time.strftime('%l:%M %p')
    else
      occurs_on.strftime('%b %d, %Y')
    end
  end

  def as_indexed_json(options = {})
    #the methods called here are defined in this model;
    #they are included in the ElasticSearch
    #cluster index for Events as 'method_name: value'
    #once an event is added to the cluster that has
    #values for content_category_ids, or title, or description, etc.
    #e.g., if title has value 'foo', and is the first event to have
    #a title, then title is then added to mapping, where before it was not present.
    as_json(methods: %i[title subtitle description price url phone start_time end_time meta_description facebook_id slug published_status hide_full_address import_pending main_image content_category_ids content_tag_ids event_image_placement kind event_feed_id business_id])
  end

  def title
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.title
  end

  def subtitle
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.subtitle
  end

  def description
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.description
  end

  def price
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.price
  end

  def url
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.url
  end

  def phone
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.phone
  end

  def start_time
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.start_time
  end

  def end_time
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.end_time
  end

  def meta_description
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.meta_description
  end

  def facebook_id
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.facebook_id
  end

  def business_id
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.business_id
  end

  def slug
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.slug
  end

  def published_status
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.published_status
  end

  def hide_full_address
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.hide_full_address
  end

  def event_image_placement
    event_definition.event_image_placement
  end

  # Other Fields that should be added for Elsticsearch
  # external_type: text
  # external_id: text
  # show_city_only: boolean
  # private: boolean
  # virtual_event: boolean
  # rsvp_required: boolean

  def kind
    event_definition.kind.to_s
  end
  # embed: text

  # event_feed_id: integer
  def event_feed_id
    event_definition.event_feed_id
  end

  def import_pending
    #leveraged in as_indexed_json for ElasticSearch
    event_definition.import_pending
  end

  # type: string
  # archived: boolean
  # imported_event_id: text

  def main_image
    event_definition.main_image
  end

  def content_category_ids
    #leveraged in as_indexed_json below for ElasticSearch
    @content_category_ids ||= event_definition&.content_category_ids || []
  end

  def content_tag_ids
    #leveraged in as_indexed_json below for ElasticSearch
    @content_tag_ids ||= event_definition&.content_tag_ids || []
  end


  def share_image_url
    event_definition.event_image.try(:attachment_full_url, :original)
  end

  # This is not a duplicate of share_image_url
  # This method works with spaces in image names for og:images
  # share_image_url strips the url special chars when this leaves them.
  def og_image_url
    event_definition.event_image.try(:attachment_full_url, :jumbo)
  end

  def image_size
    FastImage.size(self.og_image_url)
  end

  def share_callback_url
    if self.business.webhost_primary? && !self.business.is_on_engage_plan?
      url_for("http://#{self.business.website.host}/#{path_to_external_content(self)}")
    elsif self.business.is_on_engage_plan?
      "http://#{ENV['LISTING_HOST']}#{self.business.generate_listing_path}/#{self.id}?content=event"
    end
  end

  # def published_at
  #   created_at
  # end

  def to_generic_param
    {
      year: occurs_on.strftime('%Y'),
      month: occurs_on.strftime('%m'),
      day: occurs_on.strftime('%d'),
      id: id,
      slug: event_definition.slug
    }
  end

  def to_generic_param_two
    [
      occurs_on.strftime('%Y').to_s,
      occurs_on.strftime('%m').to_s,
      occurs_on.strftime('%d').to_s,
      "#{id}",
      event_definition.slug.to_s
    ]
  end
end
