class Review < ActiveRecord::Base
  belongs_to :business
  belongs_to :contact, touch: true
  belongs_to :feedback
  belongs_to :company

  accepts_nested_attributes_for :contact

  validates :business, presence: true
  validates :contact, presence: true, associated: true
  validates :customer_email, presence: true
  validates :customer_name, presence: true
  validates :description, presence: true
  validates :overall_rating, presence: true, numericality: { in: 1..5 }
  validates :reviewed_at, presence: true

  before_validation do
    self.reviewed_at = Time.now unless reviewed_at?

    if business && !contact
      self.contact = business.contacts.where(email: customer_email).first || business.contacts.build(name: customer_name, email: customer_email, phone: customer_phone)
    end
  end

  after_save do
    self.contact.save if contact
    FacebookReviewsExportJob.perform_later(business)
    LocableReviewsExportJob.perform_later(business)
  end

  after_save do
    business.authorizations.includes(:user).where(review_notifications: true).each do |authorization|
      AuthorizationsMailer.review_notification(authorization, self).deliver_later
    end
  end

  def self.published
    where(hide: false, published: true)
  end

  def to_param
    "#{id}-#{title}".parameterize
  end

end
