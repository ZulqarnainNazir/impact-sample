class Community < ActiveRecord::Base
  has_many :community_businesses
  has_many :businesses, through: :community_businesses
  accepts_nested_attributes_for :community_businesses
  # has_many :businesses

  validates :label, presence: true

  def paid_accounts(community)
    count = 0
    if community.businesses.present?
      Business.includes(:subscription).where('community_id = ?', community).each do | b |
        if b.subscription && b.subscription.subscription_plan_id > 1
          count += 1
        end
      end
    end

    return count
    #Subscription.all.where('subscription_plan_id > ?', '1').count Business.where('community_id = ?',1).count Community.last.businesses.last.subscription
  end

  def owned_companies_count(community)
    count = 0
    # Business.where('community_id = ?', community).each do | b |
    #   if b.owned_companies.count > 1
    #     count += b.owned_companies.count
    #   end
    # end
    return count
  end

end
