class ContactMessage < ActiveRecord::Base
  attr_accessor :honey

  belongs_to :business

  validates :business, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :message, presence: true

  def self.chronological
    order(created_at: :desc)
  end

  def save(*args)
    honey.present? ? true : super
  end
end
