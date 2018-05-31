class AccountModule < ActiveRecord::Base
  belongs_to :business

  store_accessor :settings, :post, :before_after, :event, :quick_post, :job, :offer, :gallery

  enum kind: {
    marketing_missions: 0,
    content_engine: 1,
    local_connections: 2,
    customer_reviews: 3,
    form_builder: 4,
    website: 5
    #if you had another module to this list of 6, please
    #change this method in business.rb: #modules_unactivated
    #you will see why by examining that method.
    #also change _dashnav.html.slim
  }


  validates :business_id, presence: true
  validates :kind, presence: true
  before_save :auto_activate_quick_posts, if: :is_new_content_engine?
  validates_inclusion_of :active, :in => [true, false]
  validates_uniqueness_of :business_id, scope: [:kind]

  def auto_activate_quick_posts
    self.quick_post = true
  end

  def is_new_content_engine?
    if self.kind == "content_engine" && self.new_record?
      true
    else
      false
    end
  end

  def content_active?(content)
    enabled = eval("self." + content)
    if enabled.nil?
      return false
    else
      return enabled
    end
  end

  def content_enabled(content)
    #used for HTML where an attribute should be "true" when enabled would be false or nil
    #e.g., a link where disabled: true, when enabled == false
    enabled = eval("self." + content)
    if enabled.nil?
      return true
    elsif enabled == true
      return false
    elsif enabled == false
      return true
    end
  end

  #used for also for HTML
  def content_enabled_checked(content)
    enabled = eval("self." + content)
    if enabled.nil?
      return false
    else
      return enabled
    end
  end

  def self.create_module(biz_id, settings)
    business = Business.find(biz_id)
    appcues_message = ""

    if settings[:active] == true
      if business.module_present?(settings[:kind])
        acct_module = business.account_modules.where(kind: settings[:kind]).first
        acct_module.active = true
        acct_module.save

        appcues_message = appcues_create_message("reactivated", settings[:kind])
      else
        acct_module = AccountModule.create(settings)
        acct_module.business = business
        acct_module.save

        appcues_message = appcues_create_message("activated", settings[:kind])
      end
    elsif settings[:active] == false
      acct_module = business.account_modules.where(kind: settings[:kind]).first
      acct_module.active = false
      acct_module.save

      appcues_message = appcues_create_message("deactivated", settings[:kind])
    end

    if settings[:active] == true
      messages = ["marketing_missions", "content_engine", "local_connections", "customer_reviews", "form_builder"]
      notice_msg = "Success, you've activated your #{messages[settings[:kind]].humanize.downcase} now let's put it to work!"
    end

    [appcues_message, notice_msg]
  end

  private

  def self.appcues_create_message(event, kind_number)
    kind_number = kind_number.to_i
    message = ""
    if kind_number == 0
      message = "marketing_missions"
    elsif kind_number == 1
      message = "content_engine"
    elsif kind_number == 2
      message = "local_connections"
    elsif kind_number == 3
      message = "customer_reviews"
    elsif kind_number == 4
      message = "form_builder"
    elsif kind_number == 5
      message = "website"
    end
    # marketing_missions: 0,
    # content_engine: 1,
    # local_connections: 2,
    # customer_reviews: 3,
    # form_builder: 4,
    # website: 5
    "Appcues.track('module #{event}: #{message} ')"
  end
end
