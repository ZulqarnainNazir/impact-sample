module Stripe
  class CheckoutEventHandler
    def call(event)
      begin
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

      # puts "############ Session Obj ################"
      # puts session

      order = ::Order.find_by!(stripe_checkout_session_id: session[:id])

      # get customer object for name and email and store along with customer_id

      # stripe = StripeService.new(request)
      # customer = stripe.get_customer_info(session[:customer])

      # puts "############ Customer Obj ################"
      # puts customer

      address = "#{session[:shipping][:name]}, #{session[:shipping][:address][:line1]}, #{session[:shipping][:address][:line2]}, #{session[:shipping][:address][:city]}, #{session[:shipping][:address][:state]} #{session[:shipping][:address][:postal]}, #{session[:shipping][:address][:country]}"

      # binding.pry
      order.update_attributes!(first_name: "Ryan", last_name: "Frisch", email: "ryan+test@locable.com", shipping_address: address, status: 'paid',  stripe_customer_id: session[:customer])

      items = Cart.find(order.cart_id).line_items.joins(:product).where(products: {business_id: order.business_id})
      items.update_all(cart_id: nil, order_id: order.id)

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
