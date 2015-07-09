class ContactMessage < ActiveRecord::Base
  attr_accessor :honey

  belongs_to :business
  belongs_to :customer

  validates :business, presence: true
  validates :customer, presence: true, associated: true
  validates :customer_email, presence: true
  validates :customer_name, presence: true
  validates :message, presence: true

  before_validation do
    if business && !customer
      self.customer = business.customers.where(email: customer_email).first || business.customers.build(name: customer_name, email: customer_email, phone: customer_phone)
    end
  end

  after_save do
    self.customer.save if customer
  end

  after_create do
    business.authorizations.includes(:user).where(contact_message_notifications: true).each do |authorization|
      AuthorizationsMailer.contact_message_notification(authorization, self).deliver_later
    end
  end

  def self.chronological
    order(created_at: :desc)
  end

  def save(*args)
    honey.present? ? true : super
  end
end
