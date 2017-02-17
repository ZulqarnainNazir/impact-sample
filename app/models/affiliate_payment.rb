class AffiliatePayment < ActiveRecord::Base
  belongs_to :subscription_payment
  belongs_to :affiliate, :class_name => 'SubscriptionAffiliate', :foreign_key => 'subscription_affiliate_id'

  def self.get_balance(affiliate_id)
    AffiliatePayment.where("subscription_affiliate_id = ? and paid = ?", affiliate_id, false).calculate(:sum, :amount)
  end

  def self.get_unpaid_for_affiliate(affiliate_id)
	AffiliatePayment.where("subscription_affiliate_id = ? and paid = ?", affiliate_id, false)
  end

  protected

end
