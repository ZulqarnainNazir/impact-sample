class Community < ActiveRecord::Base
  has_many :businesses

  def paid_accounts(community)
    count = 0
    Business.includes(:subscription).where('community_id = ?', community).each do | b |
      if b.subscription.subscription_plan_id > 1
        count += 1
      end
    end

    return count
    #Subscription.all.where('subscription_plan_id > ?', '1').count Business.where('community_id = ?',1).count Community.last.businesses.last.subscription

  end
end
