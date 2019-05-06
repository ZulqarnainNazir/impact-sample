class Community < ActiveRecord::Base
  has_many :community_businesses
  has_many :businesses, through: :community_businesses
  accepts_nested_attributes_for :community_businesses

  validates :label, presence: true

  # def accounts_count(community)
  #   count = 0
  #   if community.businesses.present?
  #     community.businesses.each do | b |
  #     # Business.communities.includes(:subscription).each do | b |
  #       if b.in_impact
  #         count += 1
  #       end
  #     end
  #   end
  #
  #   return count
  # end
  #
  # def paid_accounts_count(community)
  #   count = 0
  #   if community.businesses.present?
  #     # community.businesses.all.joins(:subscription).where('subscription.subscription_plan_id > ?', '1').each do |b|
  #     community.businesses.includes(:subscription).each do | b |
  #       if b.subscription && b.subscription.subscription_plan_id > 1
  #         count += 1
  #       end
  #     end
  #   end
  #
  #   return count
  #   #Subscription.all.where('subscription_plan_id > ?', '1').count Business.where('community_id = ?',1).count Community.last.businesses.last.subscription
  # end

  # def related_businesses_count(community)
  #   count = 0
  #   # Business.where('community_id = ?', community).each do | b |
  #   community.businesses.each do | b |
  #     # puts b.name
  #     if b.owned_companies.count >= 1
  #       count += b.owned_companies.count
  #       # puts count
  #     end
  #   end
  #   return count
  # end

  def supporters_count(community)
    count = 0
    community.businesses.each do |b|
      count += b.listed_by_business.count
    end
    return count
  end

  def supporting_count(community)
    count = 0
    community.businesses.includes(:company_lists).each do |b|
      companies = []
      b.company_lists.each {|list| companies = companies.concat(list.companies)}
      count += companies.uniq.size
    end
    return count
  end

  # def ambassador_count(community)
  #   count = 0
  #   community.community_businesses.each do | b |
  #     if b.anchor? || b.champion?
  #       # if b.is_anchor? || b.is_champion?
  #       count += 1
  #     end
  #   end
  #   return count
  # end

end
