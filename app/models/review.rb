class Review < ActiveRecord::Base
  belongs_to :business

  validates :business, presence: true
  validates :external_user_id, presence: true, uniqueness: { scope: [:business, :external_user_type] }
  validates :external_user_name, presence: true
  validates :external_user_type, presence: true
  validates :rating, presence: true
  validates :reviewed_at, presence: true
  validates :title, presence: true

  def to_param
    "#{id}-#{title}".parameterize
  end
end
