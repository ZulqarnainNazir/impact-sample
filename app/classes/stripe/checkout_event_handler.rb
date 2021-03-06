module Stripe
  class CheckoutEventHandler
    def call(event)
      begin
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
        method = "handle_" + event.type.tr('.', '_')
        self.send method, event
      rescue JSON::ParserError => e
        # handle the json parsing error here
        raise # re-raise the exception to return a 500 error to stripe
      rescue NoMethodError => e
        #code to run when handling an unknown event
        # DevMailer.unsupported_webhook_notification(event.type, event.data.object.to_s).deliver_later
      end
    end

    # Example
    # events.subscribe 'payment_intent.created' do |event|
    #   # Define subscriber behavior based on the event object
    #   # event.class       #=> Stripe::Event
    #   # event.type        #=> "charge.failed"
    #   # event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>
    # end

    def handle_checkout_session_completed(event)
      puts "############ CHECKOUT SESSION COMPLETED WEBHOOK ################"

      session = event.data.object

      order = ::Order.find_by!(stripe_checkout_session_id: session[:id])

      # Get Customer Info from Payment Intent
      # Doesn't use Stripe Service Object because request variable doesn't exist here
      customer = Stripe::PaymentIntent.retrieve(session[:payment_intent], stripe_account: order.business.stripe_connected_account_id)
      name = customer[:charges][:data][0][:billing_details][:name]
      email = customer[:charges][:data][0][:billing_details][:email]

      if session[:shipping]
        address = "#{session[:shipping][:name]}, #{session[:shipping][:address][:line1]}, #{session[:shipping][:address][:line2].present? ? session[:shipping][:address][:line2] : ''}#{session[:shipping][:address][:line2].present? ? ',' : ''} #{session[:shipping][:address][:city]}, #{session[:shipping][:address][:state]} #{session[:shipping][:address][:postal]}, #{session[:shipping][:address][:country]}"
      else
        address = "Not Applicable"
      end

      order.update_attributes!(name: name, email: email, shipping_address: address, status: 'processing', stripe_customer_id: session[:customer], order_date: DateTime.now)

      cart = Cart.find(order.cart_id)
      items = cart.line_items.joins(:product).where(products: {business_id: order.business_id, status: 1})
      items.update_all(cart_id: nil, order_id: order.id)

      #Send email confirmation and notification

      # order.send_notifications
      OrderMailer.order_confirmation(order).deliver_later
      order.business.users.where.not(confirmed_at: nil).each do |user|
        OrderMailer.order_notification(user.email, order).deliver_later
      end

      # Cleanup cart if empty (including other businesses)
      unless cart.line_items.size > items.size
        Cart.destroy(order.cart_id)
      end
    end

    # def handle_customer_subscription_updated(event)
    #   puts "############ Customer Subscription Updated Webhook ################"
    # end
    #
    # def handle_invoice_created(event)
    #   puts "############ Invoice Created Webhook ################"
    # end
    #
    # def handle_invoice_upcoming(event)
    #   puts "############ Invoice Upcoming Webhook ################"
    # end
    #
    # def handle_invoice_updated(event)
    #   puts "############ Invoice Updated Webhook ################"
    # end
    #
    # def handle_invoice_finalized(event)
    #   puts "############ Upcoming Finalized Webhook ################"
    # end
    #
    # # invoice.payment_succeeded
    # def handle_invoice_payment_succeeded(event)
    #   puts "############ Invoice Payment Succeeded Webhook ################"
    #   # TODO- this is old, need to udpate
    #   # UserMailer.email_receipt(event.data.object.customer, event.data.object.subscription).deliver_later
    #   # DevMailer.test_notification(event.type, event.data.object.to_s).deliver_later
    #
    # end

  end
end
