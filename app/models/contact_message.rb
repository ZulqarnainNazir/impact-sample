class ContactMessage < ActiveRecord::Base
  attr_accessor :honey

  belongs_to :business
  belongs_to :contact

  validates :business, presence: true
  validates :contact, presence: true, associated: true
  validates :customer_email, presence: true
  validates :customer_first_name, presence: true
  validates :customer_last_name, presence: true
  validates :message, presence: true

  before_validation do
    if business && !contact
      self.contact = business.contacts.where(email: customer_email).first || business.contacts.build(first_name: customer_first_name, last_name: customer_last_name, email: customer_email, phone: customer_phone)
    end
  end

  after_save do
    self.contact.save if contact
  end

  after_create do
    business.authorizations.includes(:user).where(contact_message_notifications: true).each do |authorization|
      AuthorizationsMailer.contact_message_notification(authorization, self).deliver_later
    end
  end

  def self.chronological
    order(created_at: :desc)
  end

  def name
    "#{customer_first_name} #{customer_last_name}"
  end


  def save(*args)
    m = ValidEmail2::Address.new(customer_email)
    if !honey.present? && m.valid? && m.valid_mx? && !m.disposable? && !m.blacklisted?
      super
    else
      true
    end
  end
end
