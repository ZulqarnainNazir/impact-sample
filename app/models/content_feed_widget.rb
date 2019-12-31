class ContentFeedWidget < ActiveRecord::Base
  include Concerns::BusinessIds
  after_initialize :init
  belongs_to :business
  has_many :content_feed_widget_content_categories, :dependent => :destroy
  has_many :content_feed_widget_content_tags, :dependent => :destroy
  has_many :content_categories, :through => :content_feed_widget_content_categories
  has_many :content_tags, :through => :content_feed_widget_content_tags

  validates :name, presence: true

  enum link_version: { link_none: 0, link_internal: 1, link_external: 2, link_paginate: 3 }

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
     ["PaidJob", "Paid Jobs"],
     ["VolunteerJob", "Volunteer Jobs"],
     ["CustomPost", "Custom Posts"]]
  end

  def link_internal_url

    webpage = self.business.website.webpages.find(self.link_id)

    if webpage.type == 'HomePage'
        Rails.application.routes.url_helpers.website_root_url(host: self.business.website.host)
    else
      # self.link_id.blank? ? '/' : Rails.application.routes.url_helpers.website_custom_page_path(Business.find(self.business_id).website.webpages.find(self.link_id).pathname)
      self.link_id.blank? ? '/' : Rails.application.routes.url_helpers.website_custom_page_path(webpage.pathname)
    end
  end

end
