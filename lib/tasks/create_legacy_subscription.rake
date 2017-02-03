desc "Setup Subscriptions"
task :create_legacy_subscription => :environment do

  SubscriptionPlan.create(
      name: 'Legacy',
      amount: 0.0, #monthly amount
      setup_amount: 0.0,
      amount_annual: 0.0,
      activated: true
    )

end