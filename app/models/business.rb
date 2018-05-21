# coding: utf-8
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

  enum kind: { traditional_business: 0, group_or_cause: 1, nonprofit_business: 2 }
  enum plan: { free: 0, web: 1, primary: 2, }

  with_options dependent: :destroy do
    has_many :account_modules
    has_many :authorizations
    has_many :before_afters
    has_many :categorizations, as: :categorizable
    has_many :contact_messages
    has_many :content_categories
    has_many :content_tags
    has_many :contacts
    has_many :event_definitions
    has_many :jobs
    has_many :feedbacks
    has_many :galleries
    has_many :lines
    has_many :offers
    has_many :posts
    has_many :quick_posts
    has_many :reviews
    has_many :team_members
    has_many :mission_instances
    has_many :missions, through: :mission_instances
    has_many :to_do_lists, through: :missions
    has_many :to_dos
    has_many :to_do_notification_settings
    has_many :review_widgets
    has_many :directory_widgets
    has_many :calendar_widgets
    has_many :contact_form_widgets
    has_many :content_feed_widgets
    has_many :company_lists
    has_many :contact_forms
    has_many :form_submissions
    has_one :mission_notification_setting
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
  has_one :company, :class_name => "Company", :foreign_key => "company_business_id"
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
  before_save :generate_slug, unless: :slug?
  # after_create :generate_intercom_company

  def associate_users_with_intercom_company(options = {})
    # associates users with company.
    # IMPORTANT: company will NOT appear in Intercom's UI unless it is associated with a user.
    # however, the company will still be saved in Intercom's db.
    # also, note that users in Intercom are only created or updated; if a user is found by its email or user_id
    # (the only 2 attributes by which a user on Intercom can be looked-up),
    # then the code below will not overwrite that user, or add a second such user; it will only
    # update this pre-existing user.
   self.users.each do |user|
     Intercom::Client.new(
        token: ENV['intercom_access_token']
      ).users.create(
      :email => user.email,
      :user_id => user.id,
      :name => user.name,
      :companies => [{:company_id=> self.id}]
     )
   end
  end

  def date_plan_changed
    plan_name = "none"
    plan_change_date = "none"
    if self.has_plan?
      plan_name = self.subscription.plan.name
      plan_change_date = self.subscription.plan.updated_at
    end
    return plan_name
  end

  def biz_hours
    hours = "N/A"
    if self.location.present? && self.location.openings.present?
      hours = self.location.openings.first.hours
    end
    return hours
  end

  def update_intercom_company(options = {})
    # FROM: https://developers.intercom.com/reference#create-or-update-company
    #   The custom_attributes object allows you to send any information you wish about a company with the following restrictions -
    #   Field names must not contain Periods (.) or Dollar ($) characters
    #   Field names must be no longer than 190 characters.
    #   Field values must be JSON Strings, Numbers or Booleans - Objects and Arrays will be rejected.
    #   String field values must be no longer than 255 characters.
    #   Maximum of 100 fields.
     plan_name = "none"
     plan_change_date = "none"
     if self.has_plan?
       plan_name = self.subscription.plan.name
       plan_change_date = self.subscription.plan.updated_at
     end
     hours = "N/A"
     if self.location.present? && self.location.openings.present?
       hours = self.location.openings.first.hours
     end
     Intercom::Client.new(
        token: ENV['intercom_access_token']
      ).companies.create(
         :company_id => self.id,
         :name => self.name,
         :plan => plan_name,
         :website => self.website_url,
         :custom_attributes => {
           :plan_change_date => plan_change_date,
           #business attributes
           :has_logo => self.logo_placement.present?,
           :hours_of_operation => hours,
           :description => self.description.present? ? self.description.truncate(200) : "N/A", #truncated due to Intercom limit of 255 characters;
           :membership_org => self.membership_org,
           :account_create_date => self.created_at,
           :account_claim_date => self.created_at,
            # todos
           :to_dos_enabled => self.to_dos_enabled,

           #modules
           :activated_mission_count => self.missions.where(status: "active").count,
           :marketing_missions_module => self.module_active?(0),
           :content_engine_module => self.module_active?(1),
           :local_connections_module => self.module_active?(2),
           :customer_reviews_module => self.module_active?(3),
           :form_builder_module => self.module_active?(4),
           :website_module => self.module_active?(5),

            #CRM stuff
           :landing_page_count => self.count_landing_pages,
           :contact_form_count => self.contact_forms.count,
           :forms_submissions_count => self.count_contact_forms_submissions,
           :company_lists_count => self.company_lists.count, #number of networks
           :companies_in_crm_count => self.owned_companies.count, #number of companies in networks
           :contacts_in_crm_count => self.contacts.count, #number of people in networks
           :directory_count => self.directory_widgets.count, #number of directories
           :calendar_count => self.calendar_widgets.count, #number of calendars
           :reviews_requested_total => self.feedbacks.count, #number of feedback reviews requested
           :reviews_received_total => self.reviews.count,

            #social media stuff
           :facebook_id => self.facebook_id,
           :google_plus_id => self.google_plus_id,
           :linkedin_id => self.linkedin_id,
           :twitter_id => self.twitter_id,
           :youtube_id => self.youtube_id,
           :instagram_id => self.instagram_id,
           :pinterest_id => self.pinterest_id,
           :yelp_id => self.yelp_id,
           :cce_id => self.cce_id,
           :zillow_id => self.zillow_id,
           :opentable_id => self.opentable_id,
           :trulia_id => self.trulia_id,
           :realtor_id => self.realtor_id,
           :tripadvisor_id => self.tripadvisor_id,
           :houzz_id => self.houzz_id,
         }
       )
  end


  #def generate_intercom_company
  #  plan = "none"
  #  if self.has_plan?
  #    plan = self.subscription.plan.name
  #  end
  #   Intercom::Client.new(
  #     app_id: ENV['INTERCOM_ID'],
  #     api_key: ENV['INTERCOM_API_KEY']
  #   ).companies.create(
  #   :company_id => self.id,
  #   :name => self.name,
  #   :plan => plan,
  #   :custom_attributes => { :account_create_date => self.created_at }
  #   )
  #end

  def count_contact_forms_submissions
    submissions_array = []
    self.contact_forms.each {|n| submissions_array << n.form_submissions.count}
    return submissions_array.inject(0, :+)
  end

  def count_landing_pages
    #unique syntax for querying PostgreSQL's json fields
    if self.website
      return self.website.webpages.where("settings->>'hide_navigation' = ?", "1").count
    else
      return 0
    end
  end

  def has_active_content?
    if self.offers.where(published_status:true).exists? || self.event_definitions.where(published_status:true).exists? || self.posts.where(published_status:true).exists? || self.quick_posts.where(published_status:true).exists? || self.galleries.where(published_status:true).exists? || self.jobs.where(published_status: true).exists?
      true
    else
      false
    end
  end

  def create_and_enable_all_modules
    count = [0, 1, 2, 3, 4, 5]
    content_type = [:post, :before_after, :event, :quick_post, :job, :offer, :gallery]
    count.each do |kind|
      @module = AccountModule.new(kind: kind, active: true)
      @module.business = self
      if kind == 1
        content_type.each do |content_type|
          @module.send("#{content_type}=", true)
        end
      end
      @module.save
    end
  end

  def create_and_enable_content_engine
    content_type = [:post, :before_after, :event, :quick_post, :job, :offer, :gallery]
    @module = AccountModule.new(kind: 1, active: true)
    @module.business = biz
    content_type.each do |content_type|
      @module.send("#{content_type}=", true)
    end
    @module.save
  end

  def enabled_content_types
    enabled_types = []
    if self.module_present?(1) && !self.account_modules.where({kind: 1}).first.settings.nil?
      self.account_modules.where({kind: 1}).first.settings.each do |key, value|
        if value == true
          enabled_types << key
        end
      end
    end
    enabled_types
  end

  def modules_unactivated
    if self.account_modules
      6 - self.account_modules.where({active: true}).count
    else
      6
    end
  end

  def any_content_type_active?
    if self.module_present?(1) && !self.account_modules.where({kind: 1}).first.settings.nil?
      self.account_modules.where({kind: 1}).first.settings.each do |key, value|
        if value == true
          return true
        end
      end
    end
    return false
  end

  def content_type_active?(content_type)
    if self.module_present?(1) && !self.account_modules.where({kind: 1}).first.settings.nil?
      self.account_modules.where({kind: 1}).first.content_active?(content_type)
    else
      false
    end
  end

  def content_type_enabled?(content_type)
    #used for HTML where an attribute should be "true" when enabled would be false or nil
    #e.g., a link where disabled: true, when enabled == false
    if self.module_present?(1) && !self.account_modules.where({kind: 1}).first.settings.nil?
      return self.account_modules.where({kind: 1}).first.content_enabled(content_type)
    else
      true
    end
  end

  def module_active?(module_kind_number)
    # marketing_missions: 0,
    # content_engine: 1,
    # local_connections: 2,
    # customer_reviews: 3,
    # form_builder: 4,
    # website: 5
    if self.account_modules.where({kind: module_kind_number, active: true}).present?
      true
    else
      false
    end
  end

  def module_present?(module_kind_number)
    if self.account_modules.where({kind: module_kind_number}).present?
      true
    else
      false
    end
  end

  def get_account_module(module_kind_number)
    m = self.account_modules.where({kind: module_kind_number}).first
    if !m.nil?
      m
    end
  end

  def create_default_directories
    case self[:kind]
    when 0
      default_list = self.company_lists.create(:name => "Support and Endorse", :sort_by => 0)
    when 1
      default_list = self.company_lists.create(:name => "Sponsors and Supportors", :sort_by => 0)
    end
    self.directory_widgets.create(:company_list_id => default_list.id, :name=> default_list.name, :enable_search => true)
    if self[:membership_org]
      member_list = self.company_lists.create(:name => "Members", :sort_by => 0)
      self.directory_widgets.create(:company_list_id => member_list.id, :name=> "Member Directory", :enable_search => true)
    end
  end

#One column should be "Active Account" with options "True" if there's an owner,
#"Sample" if account ID but no owner, "False" if no ID.

  # def biz_sent_invite_to_company(company_id)?
  #   if self.owned_companies.where(id: company_id).present && Invite.where(company_id: 768).present?
  #     return true
  #   else
  #     return false
  #   end
  # end

  def reviews_limit?
    if self.is_on_engage_plan?
      if self.reviews.count >= 5
        true
      else
        false
      end
    else
      false
    end
  end

  def merge_crm_relations(business_ids)
    #this method takes the business_ids of businesses the admin wants to merge into
    #self, and changes CRM relations so that the businesses to be merged now have their
    #associated CRM records pointing to self.

    business_ids.each do |biz|

      @biz = Business.find(biz) #get the business
      has_many_tables = [] #create an empty array

      companies = @biz.owned_by_business #has_many
      contacts = @biz.contacts #has_many
      feedbacks = @biz.feedbacks #has_many
      reviews = @biz.reviews #has_many

      has_many_tables += [contacts, feedbacks, reviews, companies] #store has_many relationships here

      # if !business.in_impact?
      #   invites = @biz.invites
      #   invites.each do |invite|
      #     if invite
      # end

      has_many_tables.each do |table| #change parent
        table.each do |record|
          record.business = self
          record.save
        end
      end

      @biz.delete

    end

  end

  def self.merge_search(query, business)
    return Business.search(query).where("id != ?", business.id)
  end

  def build_plan_no_setup_fee
    if !self.subscription.nil?
      if self.subscription.plan.present? and self.subscription.plan.name == "Build"
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def self.listing_lookup(params)
    #this method is for use RE listings subdomain (see constraints for listings in routes, and listing controller)
    #the purpose is to get the id of the business from the URL string
    exp = /\W\d*\W/ #first we get a regular expression that gets patterns mathching '-integer-', i.e., '-4-'
    id = /\d+/ #this will get an integer from '-4-'
    Business.find(id.match(exp.match(params).to_s).to_s.to_i)
    #^finally, we use the regex to get the id from the params. the id should be the first
    #integer in the URL (see generate_listing_path, below). although the business
    #name might also have a pattern matching '-integer-', our use of match here ensures that the
    #FIRST match is returned only.
    #sample test string: "nm-40-asdfadfs-na-1-asdfad"
  end

  def has_plan?
    if self.subscription.present? && self.subscription.plan.present?
      true
    else
      false
    end
  end

  def webhost_primary?
    if self.website.present? && self.website.webhost.present? && self.website.webhost.primary == true
      return true
    else
      return false
    end
  end

  def contacts_limit?
    if self.is_on_engage_plan?
      if self.contacts.count >= 100
        true
      else
        false
      end
    else
      false
    end
  end

  def generate_listing_path
    if !self.location.state.nil?
      "/#{self.location.state}-#{self.id}-#{self.sitemap_name}"
    elsif self.location.state.nil? || self.location.state.empty?
      "/na-#{self.id}-#{self.sitemap_name}"
    end
  end

  def generate_listing_segment
    #for use in route helpers
    if !self.location.state.nil?
      "#{self.location.state}-#{self.id}-#{self.sitemap_name}"
    elsif self.location.state.nil? || self.location.state.empty?
      "na-#{self.id}-#{self.sitemap_name}"
    end
  end

  def account_status
    #checks the ownership and user relationships with business
    if self.owners.present?
      return 'true'
    elsif self.users.present? && !self.owners.present?
      return 'sample'
    elsif !self.owners.present? && !self.owners.present?
      'false'
    else
      'no data available'
    end
  end

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
      if self.subscription.plan.present? and self.subscription.plan.is_engage_plan?
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
      if self.subscription.plan.present? and self.subscription.plan.is_legacy?
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
    before_afters.count + event_definitions.count + galleries.count + offers.count + posts.count + quick_posts.count + jobs.count
  end

  def website_url=(value)
    if value.to_s.match(/\Ahttp/)
      super(value.to_s)
    else
      super("http://#{value}")
    end
  end

  def sitemap_name
    (self.name.to_s).parameterize
  end

  def sitemap_url
    "https://s3.amazonaws.com/#{Rails.application.secrets.aws_s3_bucket}/sitemaps/#{self.id}/sitemap.xml.gz"
    # "http://s3-#{Rails.application.secrets.aws_s3_region}.amazonaws.com/#{Rails.application.secrets.aws_s3_bucket}/sitemaps/#{self.id}/sitemap.xml.gz"
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

  def social
    social_links =  { facebook: facebook_id,
                      twitter: twitter_id,
                      google_plus: google_plus_id,
                      youtube: youtube_id,
                      linkedin: linkedin_id,
                      pinterest: pinterest_id,
                      instagram: instagram_id,
                      yelp: yelp_id,
                      citysearch: citysearch_id,
                      foursquare: foursquare_id,
                      zillow: zillow_id,
                      opentable: opentable_id,
                      trulia: trulia_id,
                      realtor: realtor_id,
                      tripadvisor: tripadvisor_id,
                      houzz: houzz_id
                    }
    social_links.delete_if { |key, value| value.to_s.strip == '' }
  end

  def generate_slug
    self.slug = name.gsub(/['’]/, '').gsub(/,/, '').parameterize
  end

  private

  def bootstrap_to_dos
    if to_dos_enabled && to_dos.none?
      ToDosBootstrap.new(self).run
    end
  end
end
