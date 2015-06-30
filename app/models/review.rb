class Review < ActiveRecord::Base
  belongs_to :business

  validates :business, presence: true
  validates :description, presence: true
  validates :external_id, presence: true
  validates :external_type, presence: true
  validates :external_url, presence: true
  validates :external_user_id, presence: true
  validates :external_user_name, presence: true
  validates :rating, presence: true
  validates :reviewed_at, presence: true
  validates :title, presence: true

  def to_param
    "#{id}-#{title}".parameterize
  end
end
