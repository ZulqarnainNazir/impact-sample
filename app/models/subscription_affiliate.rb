# SubscriptionAffiliate keeps track of the affiliates who are paid
# for sending traffic to your site.  The token is used for
# constructing affiliate URLs, like
# https://your.domain.com/signup?ref=foo.  The rate is the percentage
# of each subscription payment that the affiliate should receive.
# For example, a $99 monthly subscription linked to an affiliate
# with a rate of 0.10 will earn the affiliate $9 per month.
class SubscriptionAffiliate < ActiveRecord::Base
  has_many :subscriptions
  has_many :subscription_payments
  has_many :affiliate_payments
  belongs_to :business

  before_validation :populate_token
  # before_validation :populate_rate
  before_validation :populate_name

  validates_presence_of :token
  validates_uniqueness_of :token
  validates_numericality_of :rate, :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 1

  # Return the fees owed to an affiliate for a particular time
  # period. The period defaults to the previous month.
  def fees(period = (Time.now.beginning_of_month - 1).beginning_of_month .. (Time.now.beginning_of_month - 1).end_of_month)
    subscription_payments.where({ :created_at => period }).collect(&:affiliate_amount).sum
  end

  def balance
    AffiliatePayment.get_balance(self.id)
  end

  def populate_name
    if new_record? && self.name.nil?
      self.name = self.business.name
    end
  end

  # def populate_rate
  #   if new_record? && self.rate.nil?
  #     self.rate = 0.20
  #   end
  # end

  def populate_token
    if new_record? && self.token.nil?
       self.token = SecureRandom.uuid().to_s.last(8)
      while check_token?(self.token) == true
        self.token = SecureRandom.uuid().to_s.last(8)
      end
    end
  end

  def check_token?(token)
    if SubscriptionAffiliate.exists?(:token => token) == true
      return true
    else
      return false
    end
  end

end
