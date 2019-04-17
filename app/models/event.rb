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

  def published_status
    event_definition.published_status
  end

  def title
    #leveraged in as_indexed_json below for ElasticSearch
    event_definition.title
  end

  def occurs_on_with_time_timestamp
    if event_definition&.start_time
      occurs_on.strftime('%b %d, %Y') + ' at ' + event_definition.start_time.strftime('%l:%M %p')
    else
      occurs_on.strftime('%b %d, %Y')
    end
  end

  def description
    #leveraged in as_indexed_json below for ElasticSearch
    event_definition.description
  end

  def subtitle
    #leveraged in as_indexed_json below for ElasticSearch
    event_definition.subtitle
  end

  def as_indexed_json(options = {})
    #the methods called here are defined in this model;
    #they are included in the ElasticSearch
    #cluster index for Events as 'method_name: value'
    #once an event is added to the cluster that has
    #values for content_category_ids, or title, or description, etc.
    #e.g., if title has value 'foo', and is the first event to have
    #a title, then title is then added to mapping, where before it was not present.
    as_json(methods: %i[content_category_ids content_tag_ids occurs_on title description subtitle published_status])
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

  def published_at
    created_at
  end

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
