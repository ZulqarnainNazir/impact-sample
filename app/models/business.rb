class Business < ActiveRecord::Base
  include PlacedImageConcern

  store_accessor :settings,
    :automated_export_facebook_reviews,
    :automated_export_locable_events,
    :automated_export_locable_reviews,
    :automated_import_locable_events,
    :automated_import_locable_reviews,
    :automated_feedbacks_publishing,
    :automated_reviews_publishing

  enum kind: { traditional_business: 0, group_or_cause: 1, }
  enum plan: { free: 0, web: 1, primary: 2, }

  with_options dependent: :destroy do
    has_many :authorizations
    has_many :before_afters
    has_many :categorizations
    has_many :contact_messages
    has_many :content_categories
    has_many :content_tags
    has_many :customers
    has_many :event_definitions
    has_many :feedbacks
    has_many :galleries
    has_many :lines
    has_many :offers
    has_many :posts
    has_many :quick_posts
    has_many :reviews
    has_many :team_members
    has_one :location
    has_one :website
  end

  has_many :categories, through: :categorizations
  has_many :events
  has_many :images
  has_many :pdfs

  has_many :manager_authorizations, -> { manager }, class_name: Authorization.name
  has_many :owner_authorizations, -> { owner }, class_name: Authorization.name

  has_many :users, through: :authorizations
  has_many :managers, through: :manager_authorizations, source: :user
  has_many :owners, through: :owners_authorizations, source: :user

  has_placed_image :logo

  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :website

  accepts_nested_attributes_for :lines, allow_destroy: true, reject_if: proc { |a|
    a['_destroy'] == '1' || (
      a['title'].blank? &&
      a['description'].blank? &&
      a['line_images_attributes'].kind_of?(Hash) && a['line_images_attributes'].all? { |_, b|
        b['_destroy'] == '1' || (
          b['line_image_placement_attributes'].kind_of?(Hash) &&
          b['line_image_placement_attributes'].select { |k,_| !%w[kind image_business image_user].include?(k) }.values.all?(&:blank?)
        )
      }
    )
  }

  validates :kind, presence: true
  validates :name, presence: true
  validates :plan, presence: true
  validates :location, presence: true
  validates :website, presence: true

  with_options on: :requires_categories do
    validates :category_ids, presence: true
  end

  def self.search(search)
    if search
      where('LOWER(name) LIKE ?', "%#{search.downcase}%")
    else
      all
    end
  end


  def self.alphabetical
    order('LOWER(name) ASC')
  end

  def automated_feedbacks_publishing
    value = super
    value.to_i > 0 ? value.to_i : 6
  end

  def automated_reviews_publishing
    value = super
    value.to_i > 0 ? value.to_i : nil
  end

  def feed_items_count
    before_afters.count + event_definitions.count + galleries.count + offers.count + posts.count + quick_posts.count
  end

  def website_url=(value)
    if value.to_s.match(/\Ahttp/)
      super(value.to_s)
    else
      super("http://#{value}")
    end
  end
end
