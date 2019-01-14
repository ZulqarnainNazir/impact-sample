class Community < ActiveRecord::Base
  has_many :community_businesses
  has_many :businesses, through: :community_businesses
  accepts_nested_attributes_for :community_businesses
  # has_many :businesses

  validates :label, presence: true

  def accounts_count(community)
    count = 0
    if community.businesses.present?
      community.businesses.each do | b |
      # Business.communities.includes(:subscription).each do | b |
        if b.in_impact
          count += 1
        end
      end
    end

    return count
  end

  def paid_accounts_count(community)
    count = 0
    if community.businesses.present?
      community.businesses.includes(:subscription).each do | b |
      # Business.communities.includes(:subscription).each do | b |
        if b.subscription && b.subscription.subscription_plan_id > 1
          count += 1
        end
      end
    end

    return count
    #Subscription.all.where('subscription_plan_id > ?', '1').count Business.where('community_id = ?',1).count Community.last.businesses.last.subscription
  end

  def owned_by_businsess_count(community)
    count = 0
    # Business.where('community_id = ?', community).each do | b |
    community.businesses.each do | b |
      if b.owned_by_business.count > 1
        count += b.owned_by_business.count
      end
    end
    return count
  end

  def ambassador_count(community)
    count = 0
    community.community_businesses.each do | b |
      if b.is_anchor? || b.is_champion?
        count += 1
      end
    end
    return count
  end

end
