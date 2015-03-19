class ContactMessage < ActiveRecord::Base
  belongs_to :business

  validates :business, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :message, presence: true

  def self.chronological
    order(created_at: :desc)
  end
end
