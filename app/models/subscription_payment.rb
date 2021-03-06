class SubscriptionPayment < ActiveRecord::Base
  has_one :affiliate_payment
  belongs_to :subscription
  belongs_to :subscriber, :polymorphic => true
  belongs_to :affiliate, :class_name => 'SubscriptionAffiliate', :foreign_key => 'subscription_affiliate_id'

  before_create :set_info_from_subscription
  before_create :calculate_affiliate_amount
  after_create :create_affiliate_payment
  after_create :send_receipt

  def self.stats
    {
      :last_month => where(:created_at => (1.month.ago.beginning_of_month .. 1.month.ago.end_of_month)).calculate(:sum, :amount),
      :this_month => where(:created_at => (Time.now.beginning_of_month .. Time.now.end_of_month)).calculate(:sum, :amount),
      :last_30 => where(:created_at => (1.month.ago .. Time.now)).calculate(:sum, :amount)
    }
  end

  def has_affiliate_payment?
    if !self.affiliate_payment.nil?
      true
    else
      false
    end
  end

  def to_param
    transaction_id
  end

  def create_affiliate_payment
    return unless affiliate
    @ap = build_affiliate_payment(
      title: "Affiliate Commission Payment to #{affiliate.business.name}", 
      subscription_affiliate_id: self.subscription_affiliate_id, 
      description: "This commission was earned from a subscription payment made by a business you referred to us.", 
      amount: affiliate_amount
    )
    @ap.save!
  end

  protected

    def set_info_from_subscription
      self.subscriber = subscription.subscriber
      self.affiliate = subscription.affiliate
    end

    def calculate_affiliate_amount
      return unless affiliate
      self.affiliate_amount = amount * affiliate.rate
    end

    def send_receipt
      return unless amount > 0
      if setup?
        #SubscriptionNotifier.billing_info_updated(p.subscription).deliver_now
        #SubscriptionNotifier.charge_failure(p.subscription).deliver_now
        # SubscriptionNotifier.downgrade_free_notification(p.subscription).deliver_now
        #SubscriptionNotifier.free_downgrade_failure(p.subscription).deliver_now
        #SubscriptionNotifier.misc_receipt(p).deliver_now
        #SubscriptionNotifier.setup_receipt(p).deliver_now
        # SubscriptionNotifier.charge_receipt(p).deliver_now

        SubscriptionNotifier.setup_receipt(self).deliver_later(wait: 5.seconds)
      elsif misc?
        SubscriptionNotifier.misc_receipt(self).deliver_later(wait: 5.seconds)
      else
        SubscriptionNotifier.charge_receipt(self).deliver_later(wait: 5.seconds)
      end
      if !self.affiliate.nil?
        SubscriptionNotifier.affiliate_earning_notification(self).deliver_later(wait: 5.seconds)
      end
      true
    end

end
