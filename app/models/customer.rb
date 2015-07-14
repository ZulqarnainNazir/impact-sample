class Customer < ActiveRecord::Base
  belongs_to :business

  with_options dependent: :destroy do
    has_many :contact_messages
    has_many :customer_notes
    has_many :feedbacks
    has_many :reviews
  end

  has_one :feedback, -> { order('CASE WHEN score IS NULL THEN 0 ELSE 1 END ASC, completed_at DESC') }

  accepts_nested_attributes_for :customer_notes, reject_if: :all_blank
  accepts_nested_attributes_for :feedbacks

  validates :business, presence: true
  validates :email, presence: true
  validates :name, presence: true
end
