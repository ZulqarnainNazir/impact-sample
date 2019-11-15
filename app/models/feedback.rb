class Feedback < ActiveRecord::Base
  belongs_to :business
  belongs_to :contact

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
    CustomerMailer.feedback(self).deliver_later(wait: 3.days)
    CustomerMailer.feedback(self).deliver_later(wait: 1.week)
  end

  def self.complete
    where.not(completed_at: nil)
  end

  def self.incomplete
    where(completed_at: nil)
  end

  def serviced_at=(*args)
    super DatepickerParser.parse(*args)
  end

  def review_desired?
    score.to_i >= business.automated_feedbacks_publishing.to_i
  end
end
