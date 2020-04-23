class MercantileEmbed < ActiveRecord::Base
  include Concerns::BusinessIds
  after_initialize :init

  belongs_to :business
  belongs_to :company_list

  validates :name, presence: true

  enum link_version: { link_none: 0, link_internal: 1, link_external: 2, link_paginate: 3 }

  def init
    self.uuid ||= SecureRandom.uuid
  end

  def link_internal_url

    webpage = self.business.website.webpages.find(self.link_id)

    if webpage.type == 'HomePage'
        Rails.application.routes.url_helpers.website_root_url(host: self.business.website.host)
    else
      self.link_id.blank? ? '/' : Rails.application.routes.url_helpers.website_custom_page_path(webpage.pathname)
    end
  end

end
