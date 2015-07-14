class CustomerNote < ActiveRecord::Base
  belongs_to :customer

  validates :content, presence: true
  validates :user_name, presence: true

  def self.default_scope
    order(created_at: :desc)
  end
end
