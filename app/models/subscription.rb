class Subscription < ActiveRecord::Base
  belongs_to :subscriber, :polymorphic => true
  belongs_to :business, :foreign_key => 'subscriber_id'
  belongs_to :subscription_plan
  has_many :subscription_payments
  belongs_to :discount, :class_name => 'SubscriptionDiscount', :foreign_key => 'subscription_discount_id'
  belongs_to :affiliate, :class_name => 'SubscriptionAffiliate', :foreign_key => 'subscription_affiliate_id'

  before_create :set_renewal_at
  before_update :apply_discount
  before_destroy :destroy_gateway_record
  before_save :set_annual_or_monthly_renewal_date, if: :annual_changed?
  before_save :check_upgrade, if: :subscription_plan_id_changed?

  attr_accessor :creditcard, :address
  attr_reader :response

  # renewal_period is the number of months to bill at a time
  # default is 1
  validates_numericality_of :renewal_period, :only_integer => true, :greater_than => 0
  validates_numericality_of :amount, :greater_than_or_equal_to => 0
  validate :card_storage, :on => :create
  # validate :within_limits, :on => :update
  #within_limits (see method below) handles user limits for an account.
  #as of 12.14.16, this is not necessary.
  #
  # Changes the subscription plan, and assigns various properties,
  # such as limits, etc., to the subscription from the assigned
  # plan.
  #
  # When adding new limits that are specified in SubscriptionPlan,
  # if you name them like "some_quantity_limit", they will automatically
  # be used by this method.
  #
  # Otherwise, you'll need to manually add the assignment to this method.
  #

  def self.charge_projections
    {
      :seven_days => where(:next_renewal_at => (Time.now .. 7.days.from_now)).calculate(:sum, :amount)
    }
  end

  def self.aggregate_plan_stats
    {
      :overall => calculate(:count, :all),
      :last_month => where(:created_at => (1.month.ago.beginning_of_month .. 1.month.ago.end_of_month)).calculate(:count, :all),
      :this_month => where(:created_at => (Time.now.beginning_of_month .. Time.now.end_of_month)).calculate(:count, :all),
      :last_30 => where(:created_at => (1.month.ago .. Time.now)).calculate(:count, :all)
    }
  end

  def self.stats_by_plan_name
    {
      #Subscription.includes(:subscriber).where(:subscriber => nil)
      :legacy => includes(:subscription_plan).where(:created_at => (1.month.ago .. Time.now), :subscription_plans => {:name => 'Legacy'}).calculate(:count, :all),
      :engage => includes(:subscription_plan).where(:created_at => (1.month.ago .. Time.now), :subscription_plans => {:name => 'Engage'}).calculate(:count, :all),
      :build => includes(:subscription_plan).where(:created_at => (1.month.ago .. Time.now), :subscription_plans => {:name => 'Build'}).calculate(:count, :all),
      :build_with_guided_site_setup => includes(:subscription_plan).where(:created_at => (1.month.ago .. Time.now), :subscription_plans => {:name => 'Build with Guided Site Setup'}).calculate(:count, :all),
      :build_with_professional_site_setup => includes(:subscription_plan).where(:created_at => (1.month.ago .. Time.now), :subscription_plans => {:name => 'Build with Professional Site Setup'}).calculate(:count, :all),
      :build_with_hands_off_site_setup => includes(:subscription_plan).where(:created_at => (1.month.ago .. Time.now), :subscription_plans => {:name => 'Build with Hands-Off Site Setup'}).calculate(:count, :all)
    }
  end

  def plan=(plan)
    if plan.amount > 0
      # Discount the plan with the existing discount (if any)
      # if the plan doesn't already have a better discount
      plan.discount = discount if discount && discount > plan.discount
      # If the assigned plan has a better discount, though, then
      # assign the discount to the subscription so it will stick
      # through future plan changes
      self.discount = plan.discount if plan.discount && plan.discount > discount
      # self.state = 'active' #to include code about a trial perod: self.state = 'active' unless plan.trial_period?
    else
      # Free account from the get-go?  No point in having a trial
      self.state = 'active' if new_record?
    end

    #
    # Find any attributes that exist in both the Subscription and SubscriptionPlan
    # and that match the pattern of "something_limit"
    #
    limits = self.attributes.keys.select { |k| k =~ /^.+_limit$/ } &
             plan.attributes.keys.select { |k| k =~ /^.+_limit$/ }

    (limits + [:amount, :renewal_period]).each do |f|
      self.send("#{f}=", plan.send(f))
    end

    self.subscription_plan = plan
  end

  # The plan_id and plan_id= methods are convenience methods for the
  # administration interface.

  def self.search(query, constraint)
    if query && query != "" && !constraint.nil?
      if constraint == "plan"
        # includes(:subscription_plan).where(nil, :subscription_plans => ['LOWER(plan) LIKE ?', "%#{query.downcase}%"])
        joins(:subscription_plan).where(['LOWER(name) LIKE ?', "%#{query.downcase}%"])
      elsif constraint == "business_name"
        joins(:business).where(['LOWER(name) LIKE ?', "%#{query.downcase}%"])
      elsif constraint == "email"
        joins(business: [:owners]).where(['LOWER(email) LIKE ?', "%#{query.downcase}%"])
      end
    elsif query == "" || constraint.nil?
      all
    else
      all
    end
  end

  def plan
    self.subscription_plan
  end

  def plan_name
    self.plan.name
  end

  def plan_id
    subscription_plan_id
  end

  def plan_id=(a_plan_id)
    self.plan = SubscriptionPlan.find(a_plan_id) if a_plan_id.to_i != subscription_plan_id
  end

  def self.inactive_subscriptions
    where("state = ?", "inactive")
  end

  def inactive?
    state == 'inactive'
  end

  def trial_days
    (self.next_renewal_at.to_i - Time.now.to_i) / 86400
  end

  def setup_fee_plus_subscription_fee_in_pennies
    subscription = SubscriptionPlan.find(self.upgrade_to)
    if self.flagged_for_annual?
      ((subscription.setup_amount + subscription.amount_annual) * 100).to_i
    elsif !self.flagged_for_annual?
      ((subscription.setup_amount + subscription.amount) * 100).to_i
    end
  end

  def setup_fee_plus_subscription_fee
    subscription = SubscriptionPlan.find(self.upgrade_to)
    if self.flagged_for_annual? || self.annual?
      subscription.setup_amount + subscription.amount_annual
    elsif !self.flagged_for_annual? || !self.annual?
      subscription.setup_amount + subscription.amount
    end
  end

  def amount_in_pennies
    (self.plan.amount * 100).to_i
  end

  def plan_amount_in_pennies
    if !self.upgrade_to.nil? && !self.flagged_for_annual?
      (SubscriptionPlan.find(self.upgrade_to).amount * 100).to_i
    elsif !self.upgrade_to.nil? && self.flagged_for_annual?
      (SubscriptionPlan.find(self.upgrade_to).amount_annual * 100).to_i
    else
      amount_in_pennies
    end
  end

  def plan_amount
    if !self.upgrade_to.nil? && !self.flagged_for_annual?
      SubscriptionPlan.find(self.upgrade_to).amount
    elsif !self.upgrade_to.nil? && self.flagged_for_annual?
      SubscriptionPlan.find(self.upgrade_to).amount_annual
    else
      self.plan.amount
    end
  end

  def store_card(creditcard, gw_options = {})
    @response = if billing_id.blank?
      gateway.store(creditcard, gw_options)
    else
      if gateway.display_name == 'Stripe'
        customer_id= billing_id.split('|').first
        gw_options = gw_options.merge(customer: customer_id, set_default: true)
        gateway.store(creditcard, gw_options)
      else
        gateway.update(billing_id, creditcard, gw_options)
      end
    end

    if @response.success?
      if gateway.display_name == 'Stripe'
        default_card = @response.params
        default_card = default_card['sources']['data'][0] if default_card['sources']
        self.card_number = "XXXX-XXXX-XXXX-#{default_card['last4']}"
        self.card_expiration = '%02d-%d' % [default_card['exp_month'], default_card['exp_year']]
        self.billing_id = @response.params['id'] if self.billing_id.blank? && @response.params
      else
        self.card_number = creditcard.display_number
        self.card_expiration = "%02d-%d" % [creditcard.expiry_date.month, creditcard.expiry_date.year]
        self.billing_id = @response.token if self.billing_id.blank?
      end
      # set_billing
      if self.save
        return true
      else
        return false
      end
    else
      errors.add(:base, @response.message)
      false
    end
  end

  # Charge the card on file the amount stored for the subscription
  # record.  This is called by the daily_mailer script for each
  # subscription that is due to be charged.  A SubscriptionPayment
  # record is created, and the subscription's next renewal date is
  # set forward when the charge is successful.

  def charge
    if amount == 0 || (@response = gateway.purchase(amount_in_pennies, billing_id)).success?
      if self.annual == false
        update_attributes(:next_renewal_at => self.next_renewal_at.advance(:months => self.renewal_period), :state => 'active')
        subscription_payments.create(:monthly => true, :subscriber => subscriber, :amount => amount, :transaction_id => @response.authorization) unless amount == 0
      elsif self.annual == true
        update_attributes(:next_renewal_at => self.next_renewal_at.advance(:years => self.renewal_period), :state => 'active')
        subscription_payments.create(:annual => true, :subscriber => subscriber, :amount => amount, :transaction_id => @response.authorization) unless amount == 0     
      end
      true
    else
      errors.add(:base, @response.message)
      false
    end
  end

  # Charge the card on file for the initial setup fee *plus* the subscription fee.
  # This will appear as ONE charge on Stripe and in invoices.
  # This was written chiefly for use in the background job StripeChargeNowJob, for the 
  # context of a user signing up and needing to have the setup fee and subscription fee
  # charged in order to complete the sign-up process and gain access to their paid account.
  # It's CRUCIAL to note that this method will change a subscription state from INACTIVE to ACTIVE.
  # This is by design. A user signing up should have the complete charge for both setup and
  # subscription fee processed successfully BEFORE gaining access to their account.
  # Accounts for users require states to be active to be accessed, and this is the usual
  # manner in which to flip an account from inactive to active.
  # - 12.21.16
  def charge_setup_fee_plus_subscription_fee
    if amount == 0 && self.upgrade_to.nil? || (@response = gateway.purchase(
      self.setup_fee_plus_subscription_fee_in_pennies, billing_id)).success?
      if !self.annual? && !self.flagged_for_annual?
        update_attributes(:next_renewal_at => Time.now.advance(:months => self.renewal_period), :state => 'active')
        @payment = subscription_payments.create(:monthly => true, :setup => true, :subscriber => subscriber, :amount => setup_fee_plus_subscription_fee, :transaction_id => @response.authorization) unless self.plan_amount == 0
        if @payment
          self.upgrade_logic
          # SubscriptionNotifier.setup_receipt(@payment).deliver_later(wait: 5.seconds)
          self.subscriber.update_attribute('subscription_billing_roadblock', false)
          true
        end
      elsif self.annual == true || self.flagged_for_annual?
        update_attributes(:next_renewal_at => Time.now.advance(:years => self.renewal_period), :state => 'active')
        @payment = subscription_payments.create(:annual => true, :setup => true, :subscriber => subscriber, :amount => setup_fee_plus_subscription_fee, :transaction_id => @response.authorization) unless self.plan_amount == 0
        if @payment
          self.upgrade_logic
          self.subscriber.update_attribute('subscription_billing_roadblock', false)
          # SubscriptionNotifier.setup_receipt(@payment).deliver_later(wait: 5.seconds)
          true
        end
      end
    else
      errors.add(:base, @response.message)
      false
    end
  end

  #used for immediate monthly or annual charges. 
  #this method is not for initial setup charges. 
  #instead, use #charge_setup_fee_plus_subscription_fee for such a purpose.
  def charge_immediately
    if amount == 0 && self.upgrade_to.nil? || (@response = gateway.purchase(
      self.plan_amount_in_pennies, billing_id)).success?
      if !self.annual? && !self.flagged_for_annual?
        update_attributes(:next_renewal_at => Time.now.advance(:months => self.renewal_period), :state => 'active')
        @payment = subscription_payments.create(:monthly => true, :subscriber => subscriber, :amount => self.plan_amount, :transaction_id => @response.authorization) unless self.plan_amount == 0
        if @payment
          self.upgrade_logic
          true
        end
      elsif self.annual == true || self.flagged_for_annual?
        update_attributes(:next_renewal_at => Time.now.advance(:years => self.renewal_period), :state => 'active')
        @payment = subscription_payments.create(:annual => true, :subscriber => subscriber, :amount => self.plan_amount, :transaction_id => @response.authorization) unless self.plan_amount == 0
        if @payment
          self.upgrade_logic
          true
        end
      end
    else
      errors.add(:base, @response.message)
      false
    end
  end

  def upgrade_logic
    if !self.upgrade_to.nil?
      self.plan = SubscriptionPlan.find(self.upgrade_to)
      if self.flagged_for_annual?
        self.annual = true
        self.flagged_for_annual = false
        self.amount = self.plan.amount_annual
      end
      self.upgrade_to = nil
    end
    self.save
  end

  # Charge the card on file any amount you want.  Pass in a dollar
  # amount (1.00 to charge $1).  A SubscriptionPayment record will
  # be created, but the subscription itself is not modified.
  def misc_charge(amount)
    if amount == 0 || (@response = gateway.purchase((amount.to_f * 100).to_i, billing_id)).success?
      subscription_payments.create(:subscriber => subscriber, :amount => amount, :transaction_id => @response.authorization, :misc => true)
      true
    else
      errors.add(:base, @response.message)
      false
    end
  end

  # def setup_fee_charged?
  #   #remember that for setup_payment, 0 = not paid, 1 = paid, 2 = superadmin designed 
  #   #this as either paid, or not needing to be paid (or some other reason).
  #   if includes(:subscription_payments).where({ :setup_payment => 2}).present?
  #     return true
  #   else
  #     return false
  #   end
  # end

  def missing_any_payment_info?
    card_number.blank?
  end

  def needs_payment_info?
    amount > 0 && card_number.blank?
  end

  def downgrade_to_free
    @sp = SubscriptionPlan.engage_plan
    self.plan = @sp
    self.annual = false
    self.downgrade_to = nil
    self.amount = @sp.amount
    self.save
  end

  def self.find_marked_for_free_downgrade
    includes(:subscriber).where({ :downgrade_to => 1 })
  end

  def self.find_expiring_trials(renew_at = 7.days.from_now)
    includes(:subscriber).where({ :state => 'trial', :next_renewal_at => (renew_at.beginning_of_day .. renew_at.end_of_day) })
  end

  def self.find_due_trials(renew_at = Time.now)
    includes(:subscriber).where({ :state => 'trial', :next_renewal_at => (renew_at.beginning_of_day .. renew_at.end_of_day) }).select {|s| !s.card_number.blank? }
  end

  def self.find_due(renew_at = Time.now)
    includes(:subscriber).where({ :state => 'active', :next_renewal_at => (renew_at.beginning_of_day .. renew_at.end_of_day) })
  end

  def self.get_past_dues
    where("next_renewal_at < ?", Time.now)
  end

  def current?
    next_renewal_at >= Time.now
  end

  def to_s
    "#{card_number} - #{card_expiration}"
  end

  def check_upgrade
    #ensures that if a user upgrades from free (subscription_plan_id 1, the Engage plan) to paid,
    #AND there is no payment info on file,
    #then we make the subscription INACTIVE until the user adds payment info OR downgrades.
    #this is to prevent the user from click away from the cc form after upgrading
    #and getting the benefits of the new plan
    if self.subscription_plan_id_changed?
      value = self.changes.fetch("subscription_plan_id")
      if value.second > 1 && value.first == 1
        self.state = "inactive"
      elsif value.second == 1
        self.state = "active"
      end
    end
  end

  def set_annual_or_monthly_renewal_date
    if self.annual_changed?
      value = self.changes.fetch("annual")
      last_annual_payment = self.subscription_payments.where('amount = ?', self.subscription_plan.amount_annual).last
      last_monthly_payment = self.subscription_payments.where('amount = ?', self.subscription_plan.amount).last
      
      if !last_annual_payment.nil? && last_annual_payment.created_at > 1.year.ago
        if value.second == true
          self.next_renewal_at = self.next_renewal_at
        elsif value.second == false
          self.next_renewal_at = self.next_renewal_at.advance(:months => renewal_period)
        end
      elsif !last_monthly_payment.nil? && last_monthly_payment.created_at > 1.month.ago
        if value.second == true
          self.next_renewal_at = self.next_renewal_at.advance(:years => renewal_period)
        elsif value.second == false
          self.next_renewal_at = self.next_renewal_at
        end
      else
        if value.second == true
          self.next_renewal_at = Time.now.advance(:years => renewal_period)
        elsif value.second == false
          self.next_renewal_at = Time.now.advance(:months => renewal_period)
        end
      end
    end
  end

  protected

    def set_billing
      if new_record?
        if !next_renewal_at? || next_renewal_at < 1.day.from_now.at_midnight
          if subscription_plan.trial_period?
            self.next_renewal_at = Time.now.advance(subscription_plan.trial_interval.to_sym => subscription_plan.trial_period)
          else
            charge_amount = self.plan_amount_in_pennies
            # charge_amount = subscription_plan.setup_amount? ? subscription_plan.setup_amount : amount
            if (@response = gateway.purchase(charge_amount, billing_id)).success?
              subscription_payments.build(:subscriber => subscriber, :amount => self.plan_amount, :transaction_id => @response.authorization, :setup => subscription_plan.setup_amount?)
              self.state = 'active'
              if self.annual == true
                self.next_renewal_at = Time.now.advance(:years => renewal_period)
              elsif self.annual == false
                self.next_renewal_at = Time.now.advance(:months => renewal_period)
              end
            else
              errors.add(:base, @response.message)
              return false
            end
          end
        end
        self.upgrade_logic
      else
        if !next_renewal_at? || next_renewal_at < 1.day.from_now.at_midnight
          if (@response = gateway.purchase(plan_amount_in_pennies, billing_id)).success?
            subscription_payments.build(:subscriber => subscriber, :amount => self.plan_amount, :transaction_id => @response.authorization)
            self.state = 'active'
            self.next_renewal_at = Time.now.advance(:months => renewal_period)
          else
            errors.add(:base, @response.message)
            return false
          end
        else
          self.state = 'active'
        end
        self.upgrade_logic
      end

      true
    end

    def check_renewal
      if subscription.annual == true
        
      elsif subscription.annual == false

      end
    end

    def set_renewal_at
      return if subscription_plan.nil? || next_renewal_at
      if subscription_plan.trial_period?
        self.next_renewal_at = Time.now.advance(subscription_plan.trial_interval.to_sym => subscription_plan.trial_period)
      elsif self.annual == true
        self.next_renewal_at = Time.now.advance(:years => renewal_period)
      else
        self.next_renewal_at = Time.now.advance(:months => renewal_period)
      end
    end

    # If the discount is changed, set the amount to the discounted
    # plan amount with the new discount.
    def apply_discount
      if subscription_discount_id_changed?
        subscription_plan.discount = discount
        self.amount = subscription_plan.amount
      end
    end

    def gateway
      @gateway ||= ActiveMerchant::Billing::Base.gateway(Saas::Config.gateway).new(Saas::Config.credentials['gateway'])
    end

    def destroy_gateway_record
      return if billing_id.blank?
      gateway.unstore(billing_id)
      clear_billing_info
    end

    def clear_billing_info
      self.card_number = nil
      self.card_expiration = nil
      self.billing_id = nil
    end

    def card_storage
      self.store_card(@creditcard, :billing_address => @address.to_activemerchant) if @creditcard && @address && card_number.blank?
    end

    def within_limits
      return unless subscription_plan_id_changed?
      subscriber.class.subscription_limits.each do |limit, rule|
        unless (cap = subscription_plan.send(limit)).nil? || rule.call(subscriber) <= cap
          errors.add(:base, "#{limit.to_s.humanize} for new plan would be exceeded.")
        end
      end

    end
end
