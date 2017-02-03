class SubscriptionPlan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  has_many :subscriptions

  # renewal_period is the number of months to bill at a time
  # default is 1
  validates_numericality_of :renewal_period, :only_integer => true, :greater_than => 0
  validates_numericality_of :trial_period, :only_integer => true, :greater_than_or_equal_to => 0
  validates_inclusion_of :trial_interval, :in => %w(months days)
  validates :activated, inclusion: { in: [true, false] }

  attr_accessor :discount

  #get build plans that are charged monthly and have setup fees
  #similar to #self.get_annual_build_plans_with_setup_fees
  def self.get_build_plans_with_setup_fees
    build_plans = []
    names = ["Build with Guided Site Setup", 
      "Build with Professional Site Setup", 
      "Build with Hands-Off Site Setup"]
    names.each do |n|
      a = SubscriptionPlan.find_by(name: n)
      if !a.nil?
        build_plans << a
      end
    end
    if build_plans.count == 3
      return build_plans
    else
      return nil
    end
  end

  #get build plans that are charged annually and have setup fees
  #similar to #self.get_build_plans_with_setup_fees
  def self.get_annual_build_plans_with_setup_fees
    build_plans = []
    names = ["Annual Build with Guided Site Setup", 
      "Annual Build with Professional Site Setup", 
      "Annual Build with Hands-Off Site Setup"]
    names.each do |n|
      a = SubscriptionPlan.find_by(name: n)
      if !a.nil?
        build_plans << a
      end
    end
    if build_plans.count == 3
      return build_plans
    else
      return nil
    end
  end

  def is_legacy?
    if self.name == "Legacy"
      return true
    else
      return false
    end
  end


  def is_engage_plan?
    if self.name == "Engage"
      return true
    else
      return false
    end
  end

  def self.build_plan_with_no_setup_fee
  	where("name = ? and setup_amount = ?", "Build", 0.0)
  end

  def self.legacy_plan
    where("name = ?", "Legacy").first
  end

  def self.engage_plan
  	where("name = ?", "Engage").first
  end

  def to_s
    "#{self.name} - #{number_to_currency(self.amount)} / month"
  end

  def to_param
    self.name
  end

  def amount(include_discount = true)
    include_discount && @discount && @discount.apply_to_recurring? ? self[:amount] - @discount.calculate(self[:amount]) : self[:amount]
  end

  def setup_amount(include_discount = true)
    include_discount && setup_amount? && @discount && @discount.apply_to_setup? ? self[:setup_amount] - @discount.calculate(self[:setup_amount]) : self[:setup_amount]
  end

  def trial_period?
    trial_period.to_i > 0
  end

  def trial_period(include_discount = true)
    include_discount && @discount ? self[:trial_period] + @discount.trial_period_extension : self[:trial_period]
  end

  def revenues
    @revenues ||= subscriptions.group('subscriptions.state').calculate(:sum, :amount)
  end

end