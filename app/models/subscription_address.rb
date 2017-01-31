class SubscriptionAddress
  include ActiveModel::Validations

  attr_accessor :address1, :address2, :city, :state, :zip, :country, :first_name, :last_name, :phone

  def initialize(atts = {})
    atts.each {|k,v| self.send("#{k}=", v) } if atts.respond_to?(:each)
  end

  def to_activemerchant
    [:address1, :address2, :city, :state, :zip, :country, :first_name, :last_name, :phone].inject({}) do |h, field|
      h[field] = self.send(field)
      h
    end
  end

  def validate
    [:address1, :city, :state, :zip, :first_name, :last_name].each do |field|
      errors.add field, "cannot be blank" if self.send(field).blank?
    end
  end

end
