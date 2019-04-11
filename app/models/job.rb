class Job < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern
  include ContentSlugConcern

  # enum kind: { event: 0, is_aclass: 1, deadline: 2 }

  belongs_to :business, touch: true

  has_many :content_categories, through: :content_categorizations
  has_many :content_categorizations, as: :content_item
  has_many :content_taggings, as: :content_item
  has_many :content_tags, through: :content_taggings
  has_one :job_location, dependent: :destroy
  has_one :location, through: :job_location
  has_many :shares, as: :shareable, dependent: :destroy

  has_placed_image :job_image
  has_placed_image :main_image

  accepts_nested_attributes_for :job_location, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :business, if: :not_draft?
  validates_presence_of :title
  validates_presence_of :description, if: :not_draft?
  validates_presence_of :start_date, if: :not_draft?
  validates_presence_of :end_date, if: :repetition? and :not_draft?
  validate :end_date_cannot_before_start_date

  if ENV['REDUCE_ELASTICSEARCH_REPLICAS'].present?
    settings index: { number_of_shards: 1, number_of_replicas: 0 }
  end

  KIND_PAID = 0
  KIND_VOLUNTEER = 1


  def to_generic_param
    {
      year: occurs_on.strftime('%Y'),
      month: occurs_on.strftime('%m'),
      day: occurs_on.strftime('%d'),
      id: id,
      slug: slug
    }
  end

  def to_generic_param_two
    [
      occurs_on.strftime('%Y').to_s,
      occurs_on.strftime('%m').to_s,
      occurs_on.strftime('%d').to_s,
      "#{id}",
      slug.to_s
    ]
  end

  def share_callback_url
    if self.business.webhost_primary? && !self.business.is_on_engage_plan?
      url_for("http://#{self.business.website.host}/#{path_to_external_content(self)}")
    elsif self.business.is_on_engage_plan?
      "http://#{ENV['LISTING_HOST']}#{self.business.generate_listing_path}/#{self.slug}?content=job"
    end
  end

  def share_image_url
    job_image.try(:attachment_full_url, :original)
  end

  # This is not a duplicate of share_image_url
  # This method works with spaces in image names for og:images
  # share_image_url strips the url special chars when this leaves them.
  def og_image_url
    job_image.try(:attachment_full_url, :jumbo)
  end

  def image_size
    FastImage.size(self.og_image_url)
  end
  # after_save do
  #   LocableEventsExportJob.perform_later(business)
  # end

  def occurs_on
    start_date
  end

  def repetition?
    false
  end

  def end_date_cannot_before_start_date
    if ( !end_time.blank? || !end_time.nil? ) && ( !end_date.blank? || !end_date.nil? )
      time_comparison = if !end_time.blank? || !end_time.nil?
                          (end_date.to_time.to_i + end_time.to_i) < (start_date.to_time.to_i + start_time.to_i)
                        else
                          end_date.to_time.to_i < start_date.to_time.to_i
                        end
      if !end_time.blank? || !end_time.nil?
        puts end_date.to_time.to_i + end_time.to_i
      end
      if !start_time.blank? || !start_time.nil?
        puts start_date.to_time.to_i + start_time.to_i
      end
      errors.add(:end_date, "can't be before start date") if
        ( !end_date.blank? || !end_time.nil? ) and time_comparison
    end
  end

  # if ENV['REDUCE_ELASTICSEARCH_REPLICAS'].present?
  #   settings index: { number_of_shards: 1, number_of_replicas: 0 }
  # end

  def readable_kind
    if kind == 0
      "Paid"
    elsif kind == 1
      "Volunteer"
    else
      "Other"
    end
  end

  def compensation_types
    [['Hourly', 0], ['Project', 1], ['Salary', 2], ['Commission', 3], ['Negotiable', 4], ['Unpaid', 5]]
  end

  def readable_compensation_type
    compensation_types.select{|a,b| b == compensation_type}.flatten.first || "Other"
  end

  def schedule_types
    [ ['Full Time', 0],
      ['Part Time', 1],
      ['Intern', 9, { class: "paid-job-option" }],
      ['Contract', 2, { class: "paid-job-option" }],
      ['Freelance', 3, { class: "paid-job-option" }],
      ['Seasonal', 4],
      ['One-Time', 5],
      ['Project', 6],
      ['Ongoing', 7],
      ['Other', 8]
    ]
  end

  def paid?
    kind == KIND_PAID
  end

  def readable_schedule_type
    schedule_types.select{|a,b| b == schedule_type}.flatten.first || "Other"
  end

  def not_draft?
    self.published_status
  end

  def start_date=(*args)
    super DatepickerParser.parse(*args)
  end

  def end_date=(*args)
    super DatepickerParser.parse(*args)
  end

  def as_indexed_json(options = {})
    as_json(methods: %i[content_category_ids content_tag_ids published_at])
  end

  # def sorting_date
  #   created_at
  # end

  def published_at
    #published_at is used in content_feed_search.rb and content_blog_search.rb to
    #as the method an each loop leverages to sort content types before displaying them.
    #published_at also exists in other content type models, because
    # there exists the attribute "published_on" in those models.
    #published_on does not exist in Event or EventDefinition.
    #published_on was added to content type models (excluding Event/EventDefinitions)
    # after many content type records had been already been created
    #(e.g., in QuickPost, Post, BeforeAfter, etc.). This wasn't done just right,
    #resulting in a situation where sometimes published_on was nil for old
    #content types. #published_at was a method added to content types that would
    #pull published_on for sorting purposes in content_feed_search and content_
    #blog_search.rb; if published_on was nil, it will pull created_at.
    #in order to sort the payload from ES consistently, published_at
    #is added here, too, so we can sort all content types by the same method.
    #see content_feed_search.rb and content_blog_search.rb.
    created_at
  end

  def description_html
    Sanitize.fragment(description.to_s, Sanitize::Config::RELAXED).html_safe
  end
end
