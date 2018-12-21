class ContentFeedWidget < ActiveRecord::Base
  include Concerns::BusinessIds
  after_initialize :init
  belongs_to :business
  has_many :content_feed_widget_content_categories, :dependent => :destroy
  has_many :content_feed_widget_content_tags, :dependent => :destroy
  has_many :content_categories, :through => :content_feed_widget_content_categories
  has_many :content_tags, :through => :content_feed_widget_content_tags

  validates :name, presence: true

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
end
