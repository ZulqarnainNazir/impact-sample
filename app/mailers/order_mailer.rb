class OrderMailer < ApplicationMailer
  add_template_helper(ProductsHelper)
  # layout 'mailer_theme_two'
  layout 'order_mailer'

  def order_confirmation(order)
      @order = order
      @business = @order.business
      @line_items = @order.line_items
      mail(
        to: @order.email,
        from: "#{@business.name} <#{Rails.application.secrets.support_email}>",
        reply_to: @business.owners.first.email,
        subject: "We've Received Your Order - #{@business.name}",
      )
  end

  def order_fulfillment_confirmation(order)
      @order = order
      @business = @order.business
      @line_items = @order.line_items
      mail(
        to: @order.email,
        from: "#{@business.name} <#{Rails.application.secrets.support_email}>",
        reply_to: @business.owners.first.email,
        subject: "Order Processed by #{@business.name}",
      )
  end

  def order_notification(recipient, order)
      @order = order
      @business = @order.business
      @line_items = @order.line_items
      mail(
        to: recipient,
        from: "Locable <#{Rails.application.secrets.support_email}>",
        subject: "New Order Recieved",
      )
  end
end
