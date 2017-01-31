class SubscriptionNotifier < ActionMailer::Base
  include ActionView::Helpers::NumberHelper

  default :from => Saas::Config.from_email

  #IMPORTANT: #setup_environment method below is called first in many methods here to
  #establish variables based on what action the user is executing.
  #take a look at the if statement in setup_environment before proceeding.
  def setup_environment(obj)
    if obj.is_a?(SubscriptionPayment)
      @subscription = obj.subscription
      @amount = obj.amount
    elsif obj.is_a?(Subscription)
      @subscription = obj
    end
    @subscriber = @subscription.subscriber
    @email = []
    @subscriber.owners.each do |n|
      @email << n.email
    end
  end

  def welcome(subscription)
    setup_environment(subscription)
    @amount = @subscription.plan.amount
    mail(:to => @email, 
      :subject => "Your #{Saas::Config.app_name} plan")
  end

  def downgrade_free_notification(subscription)
    #sends to business that they downgraded to free (Engage) plan
    setup_environment(subscription)
    mail(:to => @email, :subject => "You downgraded to the Engage Plan")
  end

  def free_downgrade_failure(subscription)
    #sends to IMPACT to alert of a downgrade failure.
    setup_environment(subscription)
    mail(:to => 'brian@locable.com', :subject => 'Downgrade Failure!')
  end

  def trial_expiring(subscription)
    setup_environment(subscription)
    mail(:to => @email, :subject => 'Trial period expiring')
  end

  def charge_receipt(subscription_payment)
    setup_environment(subscription_payment)
    mail(:to => @email, :subject => "Your #{Saas::Config.app_name} invoice")
  end

  def setup_receipt(subscription_payment)
    #for most users, there is a setup fee that is charged when they sign up
    #this depends on the plan chosen by the user. this is charged along with
    #the first month's subscription fee in most cases.
    setup_environment(subscription_payment)
    #@amount in this case only = @setup_amount + initial subscription_amount
    @setup_amount = @subscription.plan.setup_amount #the setup amount only
    @subscription_amount = @subscription.plan.amount 
    mail(:to => @email, :subject => "Your #{Saas::Config.app_name} invoice")
  end

  def misc_receipt(subscription_payment)
    setup_environment(subscription_payment)
    mail(:to => @email, :subject => "Your #{Saas::Config.app_name} invoice")
  end

  def charge_failure(subscription)
    setup_environment(subscription)
    mail(:to => @email, :subject => "Your #{Saas::Config.app_name} renewal failed",
      :bcc => Saas::Config.from_email)
  end

  def billing_info_updated(subscription)
    setup_environment(subscription)
    mail(:to => @email, :subject => "Your #{Saas::Config.app_name} plan has been changed")
  end

  def plan_changed(subscription)
    setup_environment(subscription)
    mail(:to => @email, :subject => "Your #{Saas::Config.app_name} plan has been changed")
  end

end
