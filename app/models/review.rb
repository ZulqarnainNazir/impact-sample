class Review < ActiveRecord::Base
  belongs_to :business
  belongs_to :customer

  accepts_nested_attributes_for :customer

  validates :business, presence: true
  validates :customer, presence: true, associated: true
  validates :customer_email, presence: true
  validates :customer_name, presence: true
  validates :description, presence: true
  validates :overall_rating, presence: true
  validates :reviewed_at, presence: true
  validates :title, presence: true

  before_validation do
    self.reviewed_at = Time.now unless reviewed_at?

    if business && !customer
      self.customer = business.customers.where(email: customer_email).first || business.customers.build(name: customer_name, email: customer_email, phone: customer_phone)
    end
  end

  after_save do
    self.customer.save if customer
  end

  def self.published
    where(published: true)
  end

  def to_param
    "#{id}-#{title}".parameterize
  end
end
