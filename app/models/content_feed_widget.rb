class ContentFeedWidget < ActiveRecord::Base
  after_initialize :init
  belongs_to :business
  has_many :content_feed_widget_content_categories, :dependent => :destroy
  has_many :content_feed_widget_content_tags, :dependent => :destroy
  has_many :content_categories, :through => :content_feed_widget_content_categories
  has_many :content_tags, :through => :content_feed_widget_content_tags

  def init
    self.uuid ||= SecureRandom.uuid
  end

  def cache_sensitive_key(params)
    [params[:page], Time.at((Time.now.to_f / 5.minutes).floor * 5.minutes).to_i].reject(&:blank?).join('-').parameterize
  end

  def self.content_types
    [["QuickPost", "Quick Posts"],
     ["Event", "Events"],
     ["Gallery", "Galleries"],
     ["BeforeAfter", "Before & Afters"],
     ["Offer", "Offers"],
     ["Job", "Jobs"],
     ["CustomPost", "Custom Posts"]]
  end

  def get_business_ids
    business_ids = []
    company_list = []
    self.company_list_ids.each {|n| company_list << CompanyList.find(n) unless n == ""}
    company_list.each {|n| n.companies.each {|n| business_ids << n.business.id if n.business} }
    return business_ids
  end
end
