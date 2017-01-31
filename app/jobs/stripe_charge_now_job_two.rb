class StripeChargeNowJobTwo < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    Rails.logger.error "[#{self.class.name}] Something appears to have gone wrong #{exception.to_s}"       
  end

  def perform(subscription_id)
    subscription = Subscription.find(subscription_id)
    return unless subscription
    subscription.charge_immediately
  end
  
end