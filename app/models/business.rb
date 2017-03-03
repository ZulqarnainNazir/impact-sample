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
    has_many :contacts
    has_many :event_definitions
    has_many :feedbacks
    has_many :galleries
    has_many :lines
    has_many :offers
    has_many :posts
    has_many :quick_posts
    has_many :reviews
    has_many :team_members
    has_many :to_dos
    has_many :to_do_notification_settings
    has_many :review_widgets
    has_one :location
    has_one :website
  end

  has_one :subscription, :foreign_key => :subscriber_id
  # has_one :subscription, as: :subscriber
  has_many :categories, through: :categorizations
  has_many :events
  has_many :images
  has_many :pdfs

  has_many :manager_authorizations, -> { manager }, class_name: Authorization.name
  has_many :owner_authorizations, -> { owner }, class_name: Authorization.name

  has_many :users, through: :authorizations
  has_many :managers, through: :manager_authorizations, source: :user
  has_many :owners, through: :owner_authorizations, source: :user

  has_many :owned_companies, :class_name => "Company", :foreign_key => "user_business_id"
  has_many :owned_by_business, :class_name => "Company", :foreign_key => "company_business_id"
  belongs_to :company, :class_name => "Company", :foreign_key => "company_business_id"
  has_one :subscription_affiliate


  has_placed_image :logo

  accepts_nested_attributes_for :location, update_only: true
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
  validates :website, presence: true, :if => :in_impact?

  with_options on: :requires_categories do
    validates :category_ids, presence: true
  end

  before_save :bootstrap_to_dos, if: :to_dos_enabled_changed?

  def referred?
    if !self.subscription.nil?
      if !self.subscription.affiliate.nil?
        true
      else
        false
      end
    else
      false
    end
  end

  def get_referred_by
    if self.referred?
      self.subscription.affiliate.business
    else
      nil
    end
  end

  def unique_affiliate_url(root_url)
    root_url + "?r=#{self.subscription_affiliate.token}"
  end

  def is_affiliate?
    if !self.subscription_affiliate.nil?
      return true
    elsif self.subscription_affiliate.nil?
      return false
    end
  end

  def self.get_referred_businesses(id)
    joins(:subscription).where('subscription_affiliate_id = ?', id)
  end

  def is_on_engage_plan?
    if !self.subscription.nil?
      if self.subscription.plan.is_engage_plan?
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def is_on_legacy_plan?
    if !self.subscription.nil?
      if self.subscription.plan.is_legacy?
        return true
      else
        return false
      end
    else
      return false
    end
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

  def first_five_to_dos
    to_dos
      .where(status: ToDo.statuses[:active],
             submission_status: ToDo.submission_statuses[:pending])
      .where.not(group: 0)
      .by_due_date
      .order(:created_at)
      .order(:group)
      .limit(5)
  end

  def self.get_duplicates new_business, skip_indexes
    duplicates = {}
    new_businesses.each_with_index do |new_business, i|
      if skip_indexes.include?(i.to_s)
        next
      end
      dup = self.get_duplicate new_business
      if dup != false
        duplicates[i] = dup
      end
    end 
    if !duplicates.blank?
      duplicates
    end
  end

  def self.get_duplicate new_business
    matches = []
    if(!new_business[:location_phone_number].blank?)
      matches += joins(:location).where("regexp_replace(locations.phone_number, '[^0-9]+', '', 'g')=regexp_replace(?, '[^0-9]+', '', 'g')", new_business[:location_phone_number])
    end
    %w[name website_url facebook_id twitter_id instagram_id].each do |column|
      if(!new_business[column.to_sym].blank?)
        matches += where("LOWER(businesses.#{column})=LOWER(?)", new_business[column.to_sym])
      end
    end
    %w[location_email].each do |column|
      column_n = column[9..column.length]
      if(!new_business[column.to_sym].blank?)
        matches += joins(:location).where("LOWER(locations.#{column_n})=LOWER(?)", new_business[column.to_sym])
      end
    end
    if(!new_business[:location_street1].blank?)
      matches += joins(:location).where("LOWER(locations.street1)=LOWER(?) AND LOWER(locations.city)=LOWER(?) AND LOWER(locations.state)=LOWER(?) AND LOWER(locations.zip_code)=LOWER(?)", new_business[:location_street1], new_business[:location_city], new_business[:location_state], new_business[:location_zip_code])
    end
    if matches.blank?
      return false
    end
    counts = matches.each_with_object(Hash.new(0)) { |o, h| h[o[:id]] += 1 }
    best_match = counts.sort_by {|k,v| v}.reverse[0][0].to_i
    find(best_match)
  end

  def update_attributes_only_if_blank(attributes, create = false)
    attributes.each { |k,v| attributes.delete(k) unless read_attribute(k).blank? }
    if in_impact == true
      return true
    end
    location_attr = attributes.delete :location_attributes
    location.update_attributes_only_if_blank(location_attr, create)
    update_attributes(attributes)
  end

  private

  def bootstrap_to_dos
    if to_dos_enabled && to_dos.none?
      ToDosBootstrap.new(self).run
    end
  end
end
