module ProductsHelper

  def delivery_type_label(delivery_type)
    case delivery_type
    when 'pickup'
      "Pickup In Store Only"
    when 'ship'
      "Ships within the US"
    when 'delivery'
      "Available for Delivery"
    when 'electronic'
      "Delivered by Email"
    end
  end

  def fulfillment_types(order)
    delivery_types = order.line_items.includes(:product).pluck('products.delivery_type').uniq

    types =[]
    delivery_types.each do |type|
      types << delivery_type_label(Product.delivery_types.key(type))
    end

    types.join(', ')

  end

  def fulfillment_info(order)
    delivery_type = order.line_items.includes(:product).pluck('products.delivery_type').uniq

    if delivery_type.include?(0)
      "If any of your items require in-store pickup, please stop by anytime during normal business hours to pickup your item(s)."
    end

  end

  # def full_query_address(location)
  #   [location.address_line_one, location.address_line_two].reject(&:blank?).join(' ')
  # end
end
