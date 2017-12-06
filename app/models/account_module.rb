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
  validates_inclusion_of :active, :in => [true, false]
  validates_uniqueness_of :business_id, scope: [:kind]

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

end
