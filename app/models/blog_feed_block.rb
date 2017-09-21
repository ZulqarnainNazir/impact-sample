class BlogFeedBlock < Block
  validates :items_limit, presence: true, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 15 }

  before_validation do
    self.items_limit = 4 unless items_limit.present?
    self.theme = 'default'
  end

  def cache_sensitive_key(params)
    [params[:page], Time.at((Time.now.to_f / 5.minutes).floor * 5.minutes).to_i].reject(&:blank?).join('-').parameterize
  end

  def get_business_ids
    business_ids = []
    company_list = []
    if self.company_list_ids.present?
    	array = self.company_list_ids.split
	    array.each {|n| company_list << CompanyList.find(n) unless n == ""}
	    company_list.each {|n| n.companies.each {|n| business_ids << n.business.id if n.business} }
	end
    return business_ids
  end
end
