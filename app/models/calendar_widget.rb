class CalendarWidget < ActiveRecord::Base
  after_initialize :init
  belongs_to :business

  def init
    self.uuid ||= SecureRandom.uuid
  end

  def cache_sensitive_key(params)
    [params[:page], Time.at((Time.now.to_f / 5.minutes).floor * 5.minutes).to_i].reject(&:blank?).join('-').parameterize
  end

  def self.filter_kinds
    [[0, "Events"],
     [1, "Classes"],
     [2, "Deadlines"]]
  end

  def get_business_ids
    business_ids = []
    company_list = []
    self.company_list_ids.each {|n| company_list << CompanyList.find(n) unless n == ""}
    company_list.each {|n| n.companies.each {|n| business_ids << n.business.id if n.business} }
    return business_ids
  end

  def content_types
    return ['Event']
  end
end
