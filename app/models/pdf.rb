class Pdf < ActiveRecord::Base
  belongs_to :user
  belongs_to :business

  validates :business_id, presence: true, unless: :business
  validates :user_id, presence: true, unless: :user
end
