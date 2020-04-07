class StripeService

  def initialize(request)
    # TODO - Make sure page is SSL before initialization/Confirm this works in production
    raise ArgumentError, 'Site must be secure (https://) to process payments. See help center for more info.' unless Rails.env.development? || request.host == 'impact.locabledev.com' || request.ssl?
    # Set your secret key: remember to change this to your live secret key in production
    # See your keys here: https://dashboard.stripe.com/account/apikeys
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

  def authorize_connect_account(code)
    response = Stripe::OAuth.token({
      grant_type: 'authorization_code',
      code: "#{code}",
    })
  end

  def deauthorize_connect_account(business)
    Stripe::OAuth.deauthorize({
      client_id: "#{ENV['STRIPE_CLIENT_ID']}",
      stripe_user_id: "#{business.stripe_connected_account_id}",
    })
  end

  def create_checkout_session(business, items, success_url, cancel_url)

    # Build line_items hash needed in session from items object. Example:
    # line_items: [{
    #   name: "Cucumber from Roger's Farm",
    #   amount: 200,
    #   currency: 'usd',
    #   quantity: 10,
    # }]

    line_items = []
    items.each do |item|
      new_line_item = {}
      new_line_item[:name] = "#{item.product.name}"
      new_line_item[:amount] = (item.product.price * 100).to_i
      new_line_item[:currency] = "usd"
      new_line_item[:quantity] = item.quantity
      new_line_item[:description] = item.product.description
      new_line_item[:images] = ['https://example.com/t-shirt.png']

      line_items.push(new_line_item)
    end

    session = Stripe::Checkout::Session.create({
      billing_address_collection: 'auto',
      shipping_address_collection: {
        allowed_countries: ['US', 'CA'],
      },
      payment_method_types: ['card'],
      line_items: line_items,
      # line_items: [{
      #   name: "Cucumber from Roger's Farm",
      #   amount: 200,
      #   currency: 'usd',
      #   quantity: 10,
      # },
      # {
      #   name: "Avacadoes from Roger's Farm",
      #   amount: 400,
      #   currency: 'usd',
      #   quantity: 1,
      # }],
      # payment_intent_data: {
      #   application_fee_amount: 200,
      # },
      success_url: "#{success_url}",
      cancel_url: "#{cancel_url}",
    }, {stripe_account: "#{business.stripe_connected_account_id}"})

    return session
  end

#   def get_customer_token(site, user)
#     StripePaymentCustomer.where(site: site, user: user).first&.stripe_customer_token
#   end
#
#   def find_or_create_customer(site, user, token)
#     customer_token = get_customer_token(site, user)
#     unless customer_token.present?
#       customer_token = create_customer(site, user, token)
#     end
#
#     return customer_token
#   end
#
#   def create_customer(site, user, token)
#     customer = Stripe::Customer.create({
#       email: user.email,
#       source: token,
#     }, stripe_account: site.stripe_connected_account_id)
#
#     StripePaymentCustomer.create(user: user, site: site, stripe_customer_token: customer.id)
#     return customer.id
#   end
#
#   def charge_customer(site, user, amount)
#
#     Stripe::Charge.create({
#       customer: get_customer_token(site, user),
#       amount: amount * 100,
#       currency: "usd",
#     }, stripe_account: site.stripe_connected_account_id)
#   end
#
#   def create_or_update_card(site, user, new_card_token)
#     customer_token = get_customer_token(site, user)
#     if customer_token.present?
#       update_card(site, customer_token, new_card_token)
#     else
#       create_customer(site, user, new_card_token)
#     end
#   end
#
#   # TODO - update on all accounts?
#   def update_card(site, customer_token, new_card_token)
#     Stripe::Customer.update(customer_token, {
#       source: new_card_token,
#     }, stripe_account: site.stripe_connected_account_id)
#   end
#
#   def retrieve_customer(customer_token, site)
#     # TODO - Need to rescue no customer for cases where account disconnected
#     Stripe::Customer.retrieve(customer_token, stripe_account: site.stripe_connected_account_id)
#   end
#
#   def get_card(customer_token, card, site)
#     Stripe::Customer.retrieve_source(
#       customer_token,
#       card,
#       stripe_account: site.stripe_connected_account_id
#     )
#   end
#
#   def get_last_four(site, user)
#     customer_token = get_customer_token(site, user)
#     customer = retrieve_customer(customer_token, site)
#     card = get_card(customer_token, customer.default_source, site)
#     card.last4
#   end
#
#
#
#
#
#
#
#
#
#   def create_subscription(site, customer_token, product)
#     Stripe::Subscription.create({
#       customer: customer_token,
#       items: [
#         {
#           plan: product.name
#         }
#       ],
#       expand: ["latest_invoice.payment_intent"],
#     }, stripe_account: site.stripe_connected_account_id)
#   end
#
#   # https://stripe.com/docs/billing/subscriptions/products-and-plans
#   # There are two kinds of products: goods and services. Goods are intended for use with the Orders API while services are for subscriptions.
#   def create_product(site, product)
#     product = Stripe::Product.create({
#       name: product.name,
#       type: 'service',
#     }, stripe_account: site.stripe_connected_account_id)
#
#     # TODO- save product (id) to product table in database
#
#   end
#
#   def create_plan(site, plan, product)
#     stripe_response(stripe_call: Stripe::Plan.create({
#       currency: 'usd',
#       interval: plan.interval,
#       product: product.stripe_product_id,
#       nickname: plan.plan_name,
#       amount: plan.amount * 100,
#     }, stripe_account: site.stripe_connected_account_id)
#   )
#
#     # TODO- save plan (id) to product table in database
#
#   end

def stripe_response(stripe_call: nil)
  begin
    stripe_call
  rescue Stripe::CardError => e
    puts "Status is: #{e.http_status}"
    puts "Type is: #{e.error.type}"
    puts "Charge ID is: #{e.error.charge}"
    # The following fields are optional
    puts "Code is: #{e.error.code}" if e.error.code
    puts "Decline code is: #{e.error.decline_code}" if e.error.decline_code
    puts "Param is: #{e.error.param}" if e.error.param
    puts "Message is: #{e.error.message}" if e.error.message
  rescue Stripe::RateLimitError => e
    # Too many requests made to the API too quickly
  rescue Stripe::InvalidRequestError => e
    # Invalid parameters were supplied to Stripe's API
  rescue Stripe::AuthenticationError => e
    # Authentication with Stripe's API failed
    # (maybe you changed API keys recently)
  rescue Stripe::APIConnectionError => e
    # Network communication with Stripe failed
  rescue Stripe::StripeError => e
    # Display a very generic error to the user, and maybe send
    # yourself an email
  rescue => e
    # Something else happened, completely unrelated to Stripe
  end
end

end
