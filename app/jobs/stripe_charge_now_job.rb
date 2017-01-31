class StripeChargeNowJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    Rails.logger.error "[#{self.class.name}] Something appears to have gone wrong #{exception.to_s}"       
  end

  def perform(subscription_id)
    subscription = Subscription.find(subscription_id)
    return unless subscription
    subscription.charge_setup_fee_plus_subscription_fee
  end
  
end