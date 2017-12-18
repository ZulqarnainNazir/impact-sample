desc 'Daily task that will bill users and handle trial subscriptions'
task :run_billing => :environment do

  # Ensures that an exception doesn't kill the entire billing process
  # Thanks, expens'd! :)
  def exception_catcher
    begin
      yield
    rescue Exception => err
      Rails.logger.error("\nException in saas billing: \n#{err.message}\n\t#{err.backtrace.join("\n\t")}\n")
    end
  end

  Subscription.find_marked_for_free_downgrade.each do |sub|
    if !sub.business.nil? #put here in case of admin merge with other biz that leaves a dangling subscription; should be optimized later.
      exception_catcher { SubscriptionNotifier.free_downgrade_failure(sub).deliver_now unless sub.downgrade_to_free }
    end
  end

  Subscription.find_expiring_trials.each do |sub|
    if !sub.business.nil?
      exception_catcher { SubscriptionNotifier.trial_expiring(sub).deliver_now }
    end
  end

  # Trial subscriptions for which we have payment info.
  # This will always turn up empty unless we are collecting 
  # payment info when creating an account.
  Subscription.find_due_trials.each do |sub|
    if !sub.business.nil?
      exception_catcher { SubscriptionNotifier.charge_failure(sub).deliver_now unless sub.charge }
    end
  end

  # Charge due subscriptions
  Subscription.find_due.each do |sub|
    if !sub.business.nil?
      if sub.downgrade_to.nil? #there should never be a charge on a subscription that is slated for a downgrade
        #technically, the downgrade should happen above in Subscription.find_marked_for_free_downgrade (or similar). 
        #If an error occurs there,
        #this condition ensures a charge won't be process against a business. A subscription with a nil value in
        #downgrade_to is one that is not slated to be downgraded. If there is an integer, it is slated
        #for downgraded (the integer represents the id of the plan the user is downgrading to.)
        exception_catcher { SubscriptionNotifier.charge_failure(sub).deliver_now unless sub.charge }
      end
    end
  end

  # Subscriptions overdue for payment (2nd try)
  Subscription.find_due(5.days.ago).each do |sub|
    if !sub.business.nil?
      if sub.downgrade_to.nil?
        exception_catcher { 
          unless sub.charge
            SubscriptionNotifier.charge_failure(sub).deliver_now
            sub.update_attribute(:state, 'inactive')
          end
        }
      end
    end
  end
end