class Review < ActiveRecord::Base
  belongs_to :business
  belongs_to :customer
  belongs_to :feedback

  accepts_nested_attributes_for :customer

  validates :business, presence: true
  validates :customer, presence: true, associated: true
  validates :customer_email, presence: true
  validates :customer_name, presence: true
  validates :description, presence: true
  validates :overall_rating, presence: true, numericality: { in: 1..5 }
  validates :quality_rating, presence: true, numericality: { in: 1..5 }
  validates :reviewed_at, presence: true
  validates :service_rating, presence: true, numericality: { in: 1..5 }
  validates :title, presence: true
  validates :value_rating, presence: true, numericality: { in: 1..5 }

  before_validation do
    self.reviewed_at = Time.now unless reviewed_at?

    if business && !customer
      self.customer = business.customers.where(email: customer_email).first || business.customers.build(name: customer_name, email: customer_email, phone: customer_phone)
    end
  end

  after_save do
    self.customer.save if customer
    ReviewsExportJob.perform_later(business)
  end

  def self.published
    where(hide: false, published: true)
  end

  def to_param
    "#{id}-#{title}".parameterize
  end
end
