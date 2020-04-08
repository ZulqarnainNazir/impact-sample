Stripe.api_key = ENV['STRIPE_API_KEY']
StripeEvent.signing_secret = [
  ENV['LOCABLE_CORE_STRIPE_SIGNING_SECRET'],
  ENV['CONNECTED_ACCOUNT_STRIPE_SIGNING_SECRET'],
  ENV['CLI_STRIPE_SIGNING_SECRET'],
]

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed', Stripe::CheckoutEventHandler.new

end
