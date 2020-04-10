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

  def fulfillment_info(order)
    delivery_type = order.line_items.includes(:product).pluck('products.delivery_type').uniq

    if delivery_type.include?(0)
      "Some items may require in store pickup."
    end

  end

  # def full_query_address(location)
  #   [location.address_line_one, location.address_line_two].reject(&:blank?).join(' ')
  # end
end
