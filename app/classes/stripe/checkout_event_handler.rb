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

      puts "############ Session Obj ################"
      puts session

      order = Order.find_by(stripe_checkout_session_id: session.id)

      puts "############ Order ID: ################"
      puts "############ #{order.id} ################"

      order.update_attributes!(first_name: "Ryan", last_name: "Frisch", email: "ryan-test@locable.com", shipping_address: "4309 Grafton Cir, Mather, CA 95655", amount: 99.99, status: 1)

      # User.last
      #
      # puts user.email
      #
      # Order.create!(business_id: 177, first_name: "Ryan", last_name: "Frisch", email: "ryan-test@locable.com", shipping_address: "4309 Grafton Cir, Mather, CA 95655", amount: 99.99)
      # @order = @business.order.new(order_params)
      #
      # @current_cart.line_items.each do |item|
      #   @order.line_items << item
      #   item.cart_id = nil
      # end
      #
      # @order.save
      #

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
