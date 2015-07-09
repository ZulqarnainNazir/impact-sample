class Feedback < ActiveRecord::Base
  belongs_to :business
  belongs_to :customer

  has_one :review, dependent: :destroy

  accepts_nested_attributes_for :review

  validates :business, presence: true
  validates :token, presence: true, uniqueness: true
  validates :score, numericality: { in: 1..10 }, allow_nil: true

  before_validation do
    self.token = SecureRandom.urlsafe_base64 unless token?
  end

  after_create do
    CustomerMailer.feedback(self).deliver_later
  end

  def self.default_scope
    order(created_at: :desc)
  end

  def self.complete
    where.not(score: nil)
  end

  def self.incomplete
    where(score: nil)
  end

  def serviced_at=(*args)
    super DatepickerParser.parse(*args)
  end
end