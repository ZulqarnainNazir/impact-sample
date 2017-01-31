desc "Setup Subscriptions"
task :create_subscriptions => :environment do

  SubscriptionPlan.create(
      name: 'Engage',
      amount: 0.0, #monthly amount
      setup_amount: 0.0,
      activated: true
    )

  SubscriptionPlan.create(
      name: 'Build',
      amount: 29.99,
      setup_amount: 0,
      amount_annual: 299.88, #annual amount
      activated: true
    )

  SubscriptionPlan.create(
      name: 'Build with Guided Site Setup',
      amount: 29.99,
      setup_name: 'Guided Site Setup',
      setup_amount: 375.00,
      amount_annual: 299.88,
      activated: true
    )

  SubscriptionPlan.create(
      name: 'Build with Professional Site Setup',
      amount: 29.99,
      setup_name: 'Professional Site Setup',
      setup_amount: 1250.00,
      amount_annual: 299.88,
      activated: true
    )

  SubscriptionPlan.create(
      name: 'Build with Hands-Off Site Setup',
      amount: 29.99,
      setup_name: 'Hands-Off Site Setup',
      setup_amount: 2500.00,
      amount_annual: 299.88,
      activated: true
    )

end